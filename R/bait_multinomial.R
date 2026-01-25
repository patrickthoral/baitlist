#' Fits the responses in a BAIT multinomial logistic regression model for each
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
#' fit_bait_multinomial()
fit_bait_multinomial <- function(elimination_threshold = 0.20) {

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

    # database <- database %>%
    #   dplyr::mutate(
    #     avail_withdraw = dplyr::case_when( CHOICE_MULTINOMIAL == 3 ~ 1, .default = 0),
    #     avail_continue = dplyr::case_when( CHOICE_MULTINOMIAL == 2 ~ 1, .default = 0),
    #     avail_timelimited = dplyr::case_when( CHOICE_MULTINOMIAL == 1 ~ 1, .default = 0)
    #   )

    # ################################################################# #
    #### DEFINE MODEL PARAMETERS                                     ####
    # ################################################################# #

    ### Set core controls
    apollo_control <- list(
      modelName = paste0("baitlist_", group),
      modelDescr = "Multinomial Logit Model for Life Sustaining Therapy",
      indivID = "ID",
      outputDirectory = fs::path_package("extdata/apollo/multinomial/", package = "baitlist")
    )

    ### Vector of parameters, including any that are kept fixed in estimation
    apollo_beta <- c(
      asc_continue = 0,
      b_expected_los_continue = 0,
      b_clinical_situation_continue = 0,
      b_age_continue = 0,
      b_frailty_continue = 0,
      b_life_expectancy_continue = 0,
      b_suffering_continue = 0,
      b_disability_cardiovascular_continue = 0,
      b_disability_pulmonary_continue = 0,
      b_disability_renal_continue = 0,
      b_disability_neurological_continue = 0,
      b_disability_gastrointestinal_continue = 0,
      b_family_values_continue = 0,

      asc_timelimited = 0,
      b_expected_los_timelimited = 0,
      b_clinical_situation_timelimited = 0,
      b_age_timelimited = 0,
      b_frailty_timelimited = 0,
      b_life_expectancy_timelimited = 0,
      b_suffering_timelimited = 0,
      b_disability_cardiovascular_timelimited = 0,
      b_disability_pulmonary_timelimited = 0,
      b_disability_renal_timelimited = 0,
      b_disability_neurological_timelimited = 0,
      b_disability_gastrointestinal_timelimited = 0,
      b_family_values_timelimited = 0,

      asc_withdraw = 0
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
        b_expected_los_continue * expected_los +
        b_clinical_situation_continue * clinical_situation +
        b_age_continue * age +
        b_frailty_continue * frailty +
        b_life_expectancy_continue * life_expectancy +
        b_suffering_continue * suffering +
        b_disability_cardiovascular_continue * disability_cardiovascular +
        b_disability_pulmonary_continue * disability_pulmonary +
        b_disability_renal_continue * disability_renal +
        b_disability_neurological_continue * disability_neurological +
        b_disability_gastrointestinal_continue * disability_gastrointestinal +
        b_family_values_continue * family_values

      V[["timelimited"]] = asc_timelimited +
        b_expected_los_timelimited * expected_los +
        b_clinical_situation_timelimited * clinical_situation +
        b_age_timelimited * age +
        b_frailty_timelimited * frailty +
        b_life_expectancy_timelimited * life_expectancy +
        b_suffering_timelimited * suffering +
        b_disability_cardiovascular_timelimited * disability_cardiovascular +
        b_disability_pulmonary_timelimited * disability_pulmonary +
        b_disability_renal_timelimited * disability_renal +
        b_disability_neurological_timelimited * disability_neurological +
        b_disability_gastrointestinal_timelimited * disability_gastrointestinal +
        b_family_values_timelimited * family_values

      V[["withdraw"]] = asc_withdraw


      ### Define settings for MNL model component
      mnl_settings = list(
        alternatives  = c(timelimited=1, continue=2, withdraw=3),
        avail         = list('timelimited'=1, 'continue'=1, 'withdraw'=1),
        choiceVar     = CHOICE_MULTINOMIAL,
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
      p_value <- 1 - pchisq(wald_stat, df=1)

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
    write.csv(tbl_wald,
              fs::path_package("extdata/apollo/multinomial/", paste0(apollo_control$modelName, "_weights_wald.csv"),
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
