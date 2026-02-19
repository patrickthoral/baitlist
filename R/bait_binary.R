#' Fits the responses in a BAIT binary logistic regression model for each
#' respondent group
#'
#' Uses the `apollo` package for modelling.
#'
#' @param elimination_threshold
#' Performs step-wise backward elimination of least significant coefficients using
#' p > `elimination_threshold`. Default: 0.20. To disable backward elimination of coefficients
#' set elimination_threshold = 1
#'
#' @export
#'
#' @examples
#' baitlist::fit_bait_binary(elimination_threshold = 1)
fit_bait_binary <- function(elimination_threshold = 0.20) {

  groups <- c(
    'aggregate',
    'aumc',
    'olvg',
    'intensivists',
    'fellows'
  )


    # ################################################################# #
    #### LOAD LIBRARY AND DEFINE CORE SETTINGS                       ####
    # ################################################################# #

    ### Load Apollo and other libraries
    library(apollo)

  for(group in groups) {
    ### Initialise code
    apollo_initialise()


    # ################################################################# #
    #### LOAD DATA AND APPLY ANY TRANSFORMATIONS                     ####
    # ################################################################# #

    database <- load_responses(group)

    # ################################################################# #
    #### DEFINE MODEL PARAMETERS                                     ####
    # ################################################################# #

    ### Set core controls
    apollo_control <- list(
      modelName = paste0("baitlist_", group),
      modelDescr = "Binary Logit Model for Life Sustaining Therapy",
      indivID = "ID",
      outputDirectory = fs::path_package("extdata/apollo/binary/", package = "baitlist")
    )

    ### Vector of parameters, including any that are kept fixed in estimation
    apollo_beta <- c(
      asc_continue = 0,
      asc_withdraw = 0,
      b_expected_los = 0,
      b_clinical_situation = 0,
      b_age = 0,
      b_frailty = 0,
      b_life_expectancy = 0,
      b_suffering = 0,
      b_disability_cardiovascular = 0,
      b_disability_pulmonary = 0,
      b_disability_renal = 0,
      b_disability_neurological = 0,
      b_disability_gastrointestinal = 0,
      b_family_values = 0
    )

    # Vector with names (in quotes) of parameters to be kept fixed at their starting value
    # in apollo_beta, use apollo_beta_fixed = c() if none
    apollo_fixed <- c("asc_withdraw")

    # ################################################################# #
    #### GROUP AND VALIDATE INPUTS                                   ####
    # ################################################################# #


    apollo_inputs <- apollo_validateInputs(
      database = database,
      apollo_beta = apollo_beta,
      apollo_fixed = apollo_fixed,
      apollo_control = apollo_control)

    # ################################################################# #
    #### DEFINE MODEL AND LIKELIHOOD FUNCTION                        ####
    # ################################################################# #

    apollo_probabilities <- function(apollo_beta, apollo_inputs, functionality="estimate"){

      ### Attach inputs and detach after function exit
      apollo_attach(apollo_beta, apollo_inputs)
      on.exit(apollo_detach(apollo_beta, apollo_inputs))

      ### Create list of probabilities P
      P = list()

      ### List of utilities: these must use the same names as in mnl_settings, order is irrelevant
      V = list()
      V[["continue"]] = asc_continue +
        b_expected_los * expected_los +
        b_clinical_situation * clinical_situation +
        b_age * age +
        b_frailty * frailty +
        b_life_expectancy * life_expectancy +
        b_suffering * suffering +
        b_disability_cardiovascular * disability_cardiovascular +
        b_disability_pulmonary * disability_pulmonary +
        b_disability_renal * disability_renal +
        b_disability_neurological * disability_neurological +
        b_disability_gastrointestinal * disability_gastrointestinal +
        b_family_values * family_values

      V[["withdraw"]] = asc_withdraw

      ### Define settings for MNL model component
      mnl_settings = list(
        alternatives  = c(withdraw=0, continue=1),
        avail         = 1, # every choice is available for each case/record
        choiceVar     = CHOICE_BINARY,
        utilities     = V
      )

      ### Compute probabilities using MNL model
      P[["model"]] = apollo_mnl(mnl_settings, functionality)

      ### Take product across observation for same individual
      P = apollo_panelProd(P, apollo_inputs, functionality)

      ### Prepare and return outputs of function
      P = apollo_prepareProb(P, apollo_inputs, functionality)
      return(P)
    }

    # ################################################################# #
    #### MODEL ESTIMATION                                            ####
    # ################################################################# #

    # first iteration

    # uses elimination_threshold argument (default 0.20)
    eliminated <- character()

    while( length(eliminated) < length(apollo_beta)) {

      model = apollo_estimate(apollo_beta,
                              apollo_fixed,
                              apollo_probabilities,
                              apollo_inputs)

      # using t-test
      # tstat <- abs(model$tstatBGW)
      # k <- length(apollo_beta)
      # n <- length(database)
      # df <- n - (k + 1)
      # p_value <- 1 - pt(q=tstat, df=df)

      # Wald-test
      coef <- model$estimate
      se <- model$robse
      wald_stat <- coef^2/se^2
      p_value <- 1 - stats::pchisq(wald_stat, df=1)

      # determine coefficients that are above threshold
      nonsig <- p_value[(p_value > elimination_threshold)]

      # select name of least significant coefficient
      to_eliminate <- names(nonsig[(which.max(nonsig))])

      if(length(to_eliminate) == 0) {
        break
      }
      eliminated <- append(eliminated, to_eliminate)

      apollo_fixed <- c(apollo_fixed, to_eliminate)

      apollo_inputs <- apollo_validateInputs(
        database = database,
        apollo_beta = apollo_beta,
        apollo_fixed = apollo_fixed,
        apollo_control = apollo_control)
    }

    if(length(eliminated) > 0) {
      cat(paste0("Covariates eliminated: ", paste0(eliminated, collapse=", "), "\n"))
    }

    # save Wald stats for weight estimates to disk
    tbl_wald <-  dplyr::tibble(coefficient_name=names(coef),
                               weight = coef,
                               robust_se = se,
                               wald = wald_stat,
                               p_value = p_value
    )
    utils::write.csv(tbl_wald,
              fs::path_package("extdata/apollo/binary/", paste0(apollo_control$modelName, "_weights_wald.csv"),
                               package = "baitlist"),
      row.names = FALSE
    )

    # ################################################################# #
    #### MODEL OUTPUTS                                               ####
    # ################################################################# #

    # ----------------------------------------------------------------- #
    #---- FORMATTED OUTPUT (TO SCREEN)                               ----
    # ----------------------------------------------------------------- #

    apollo_modelOutput(model)

    # ----------------------------------------------------------------- #
    #---- FORMATTED OUTPUT (TO FILE, using model name)               ----
    # ----------------------------------------------------------------- #

    apollo_saveOutput(model)
  }

}
