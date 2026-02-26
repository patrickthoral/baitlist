#' Fit pooled models with interaction effects for group-wise comparisons to allow
#' comparing coefficients for Amsterdam UMC vs. OLVG and
#' Intensivists vs. Fellows for both binary and multinomial models
#'
#' @export
#' @examples
#' baitlist::fit_pooled_models()
fit_pooled_models <- function() {
  comparisons <- list(
    'Amsterdam UMC vs. OLVG'=c('aumc','olvg'),
    'Intensivists vs. Fellows'=c('intensivists','fellows')
  )

  modeltypes <- c('binary', 'multinomial')

  for(modeltype in modeltypes) {

    for(title in names(comparisons)) {
      cat(paste0("Comparing: ", title, " (", modeltype, " model)\n" ))
      groups <- comparisons[[title]]

      group1 = groups[[1]]
      group2 = groups[[2]]

      if(modeltype == 'binary') {
        model_pooled  <- baitlist::fit_pooled_interaction_binary(group1, group2)
      }
      else if(modeltype == 'multinomial') {
        model_pooled  <- baitlist::fit_pooled_interaction_multinomial(group1, group2)
      }
      cat(paste0("\n\n" ))
    } # end comparison groups

  } # end model types
}

#' Fits a pooled binary model with interaction effects using data
#' from both `group1` and `group2` to allow comparing difference in
#' coefficients between groups
#'
#' @param group1 First Group
#' @param group2 Second group
#'
#' @returns Apollo model object
#' @export
#'
#' @examples
#' baitlist::fit_pooled_interaction_binary('aumc', 'olvg')
fit_pooled_interaction_binary <- function(group1, group2) {

  # required since apollo_probabilities function is not compatible with package
  # notation (apollo::fun) inside function
  library(apollo)

  apollo::apollo_initialise()

  # 1. Load and pool data -------------------------------------------

  database1 <- load_responses(group1)
  database1$group <- group1

  database2 <- load_responses(group2)
  database2$group <- group2

  database <- dplyr::bind_rows(database1, database2)
  database <- dplyr::arrange(database, ID)

  # group2 dummy
  database$is_group2 <- as.numeric(database$group == group2)

  # 2. Controls ------------------------------------------------------

  datadir <- fs::path_package("extdata", package = "baitlist")

  apollo_control <- list(
    modelName       = paste0("baitlist_pooled_", group1, "_", group2),
    modelDescr      = "Pooled binary logit with group interactions",
    indivID         = "ID",
    outputDirectory = fs::path(datadir, "apollo", "pooled", "binary")
  )

  # 3. Parameters ----------------------------------------------------

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
    b_family_values = 0,

    # interaction terms: difference in effect for group2
    d_asc_continue = 0,
    d_expected_los = 0,
    d_clinical_situation = 0,
    d_age = 0,
    d_frailty = 0,
    d_life_expectancy = 0,
    d_suffering = 0,
    d_disability_cardiovascular = 0,
    d_disability_pulmonary = 0,
    d_disability_renal = 0,
    d_disability_neurological = 0,
    d_disability_gastrointestinal = 0,
    d_family_values = 0
  )

  # Withdraw ASC is reference
  apollo_fixed <- c("asc_withdraw")

  # 4. Validate ------------------------------------------------------

  apollo_inputs <- apollo::apollo_validateInputs(
    database       = database,
    apollo_beta    = apollo_beta,
    apollo_fixed   = apollo_fixed,
    apollo_control = apollo_control
  )

  # 5. Probabilities -------------------------------------------------

  apollo_probabilities <- function(apollo_beta, apollo_inputs, functionality = "estimate") {

    apollo_attach(apollo_beta, apollo_inputs)
    on.exit(apollo_detach(apollo_beta, apollo_inputs))

    P <- list()
    V <- list()

    # group1 effect + group2 difference
    V[["continue"]] <-
      (asc_continue + d_asc_continue * is_group2) +
      (b_expected_los + d_expected_los * is_group2) * expected_los +
      (b_clinical_situation + d_clinical_situation * is_group2) * clinical_situation +
      (b_age + d_age * is_group2) * age +
      (b_frailty + d_frailty * is_group2) * frailty +
      (b_life_expectancy + d_life_expectancy * is_group2) * life_expectancy +
      (b_suffering + d_suffering * is_group2) * suffering +
      (b_disability_cardiovascular + d_disability_cardiovascular * is_group2) * disability_cardiovascular +
      (b_disability_pulmonary + d_disability_pulmonary * is_group2) * disability_pulmonary +
      (b_disability_renal + d_disability_renal * is_group2) * disability_renal +
      (b_disability_neurological + d_disability_neurological * is_group2) * disability_neurological +
      (b_disability_gastrointestinal + d_disability_gastrointestinal * is_group2) * disability_gastrointestinal +
      (b_family_values + d_family_values * is_group2) * family_values

    V[["withdraw"]] <- asc_withdraw

    mnl_settings <- list(
      alternatives = c(withdraw = 0, continue = 1),
      avail        = 1,
      choiceVar    = CHOICE_BINARY,
      utilities    = V
    )

    P[["model"]] <- apollo_mnl(mnl_settings, functionality)
    P <- apollo_panelProd(P, apollo_inputs, functionality)
    P <- apollo_prepareProb(P, apollo_inputs, functionality)

    return(P)
  }

  # 6. Estimate ------------------------------------------------------

  model <- apollo::apollo_estimate(
    apollo_beta,
    apollo_fixed,
    apollo_probabilities,
    apollo_inputs
  )

  apollo::apollo_modelOutput(model)
  apollo::apollo_saveOutput(model)

  return(model)
}

#' Fits a pooled multinomial model with interaction effects using data
#' from both `group1` and `group2` to allow comparing difference in
#' coefficients between groups
#'
#' @param group1 First Group
#' @param group2 Second group
#'
#' @returns Apollo model object
#' @export
#'
#' @examples
#' fit_pooled_interaction_multinomial('aumc', 'olvg')
fit_pooled_interaction_multinomial <- function(group1, group2) {

  # required since apollo_probabilities function is not compatible with package
  # notation (apollo::fun) inside function
  library(apollo)

  apollo::apollo_initialise()

  # -------------------------------------------------------------------
  # 1. Load and pool data
  # -------------------------------------------------------------------

  database1 <- load_responses(group1)
  database1$group <- group1

  database2 <- load_responses(group2)
  database2$group <- group2

  database <- dplyr::bind_rows(database1, database2)
  database <- dplyr::arrange(database, ID)

  # group2 dummy
  database$is_group2 <- as.numeric(database$group == group2)

  # -------------------------------------------------------------------
  # 2. Apollo controls
  # -------------------------------------------------------------------

  datadir <- fs::path_package("extdata", package = "baitlist")

  apollo_control <- list(
    modelName       = paste0("baitlist_pooled_", group1, "_", group2),
    modelDescr      = "Pooled multinomial logit with group interactions",
    indivID         = "ID",
    outputDirectory = fs::path(datadir, "apollo", "pooled", "multinomial")
  )

  # -------------------------------------------------------------------
  # 3. Parameters (mirroring your multinomial naming)
  # -------------------------------------------------------------------

  # Base parameters for CONTINUE and TIMELIMITED (withdraw is reference)
  apollo_beta <- c(

    asc_continue = 0,
    asc_timelimited = 0,
    asc_withdraw = 0,   # reference

    # Continue
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

    # Time-Limited
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

    # Interaction terms (difference in effect for group2)
    d_asc_continue = 0,
    d_asc_timelimited = 0,

    d_expected_los = 0,
    d_clinical_situation = 0,
    d_age = 0,
    d_frailty = 0,
    d_life_expectancy = 0,
    d_suffering = 0,
    d_disability_cardiovascular = 0,
    d_disability_pulmonary = 0,
    d_disability_renal = 0,
    d_disability_neurological = 0,
    d_disability_gastrointestinal = 0,
    d_family_values = 0
  )

  # Withdraw ASC is reference
  apollo_fixed <- c("asc_withdraw")

  # -------------------------------------------------------------------
  # 4. Validate inputs
  # -------------------------------------------------------------------

  apollo_inputs <- apollo_validateInputs(
    database       = database,
    apollo_beta    = apollo_beta,
    apollo_fixed   = apollo_fixed,
    apollo_control = apollo_control
  )

  # -------------------------------------------------------------------
  # 5. Probability function
  # -------------------------------------------------------------------

  apollo_probabilities <- function(apollo_beta, apollo_inputs, functionality="estimate") {

    apollo_attach(apollo_beta, apollo_inputs)
    on.exit(apollo_detach(apollo_beta, apollo_inputs))

    P <- list()
    V <- list()

    # Continue utility: group1 effect + group2 difference
    V[["continue"]] <-
      (asc_continue + d_asc_continue * is_group2) +
      (b_expected_los_continue + d_expected_los * is_group2) * expected_los +
      (b_clinical_situation_continue + d_clinical_situation * is_group2) * clinical_situation +
      (b_age_continue + d_age * is_group2) * age +
      (b_frailty_continue + d_frailty * is_group2) * frailty +
      (b_life_expectancy_continue + d_life_expectancy * is_group2) * life_expectancy +
      (b_suffering_continue + d_suffering * is_group2) * suffering +
      (b_disability_cardiovascular_continue + d_disability_cardiovascular * is_group2) * disability_cardiovascular +
      (b_disability_pulmonary_continue + d_disability_pulmonary * is_group2) * disability_pulmonary +
      (b_disability_renal_continue + d_disability_renal * is_group2) * disability_renal +
      (b_disability_neurological_continue + d_disability_neurological * is_group2) * disability_neurological +
      (b_disability_gastrointestinal_continue + d_disability_gastrointestinal * is_group2) * disability_gastrointestinal +
      (b_family_values_continue + d_family_values * is_group2) * family_values

    # Time-Limited utility: group1 effect + group2 difference
    V[["timelimited"]] <-
      (asc_timelimited + d_asc_timelimited * is_group2) +
      (b_expected_los_timelimited + d_expected_los * is_group2) * expected_los +
      (b_clinical_situation_timelimited + d_clinical_situation * is_group2) * clinical_situation +
      (b_age_timelimited + d_age * is_group2) * age +
      (b_frailty_timelimited + d_frailty * is_group2) * frailty +
      (b_life_expectancy_timelimited + d_life_expectancy * is_group2) * life_expectancy +
      (b_suffering_timelimited + d_suffering * is_group2) * suffering +
      (b_disability_cardiovascular_timelimited + d_disability_cardiovascular * is_group2) * disability_cardiovascular +
      (b_disability_pulmonary_timelimited + d_disability_pulmonary * is_group2) * disability_pulmonary +
      (b_disability_renal_timelimited + d_disability_renal * is_group2) * disability_renal +
      (b_disability_neurological_timelimited + d_disability_neurological * is_group2) * disability_neurological +
      (b_disability_gastrointestinal_timelimited + d_disability_gastrointestinal * is_group2) * disability_gastrointestinal +
      (b_family_values_timelimited + d_family_values * is_group2) * family_values

    V[["withdraw"]] <- asc_withdraw

    mnl_settings <- list(
      alternatives = c(timelimited=1, continue=2, withdraw=3),
      avail        = 1,
      choiceVar    = CHOICE_MULTINOMIAL,
      utilities    = V
    )

    P[["model"]] <- apollo_mnl(mnl_settings, functionality)
    P <- apollo_panelProd(P, apollo_inputs, functionality)
    P <- apollo_prepareProb(P, apollo_inputs, functionality)

    return(P)
  }

  # 6. Estimate ------------------------------------------------------

  model <- apollo::apollo_estimate(
    apollo_beta,
    apollo_fixed,
    apollo_probabilities,
    apollo_inputs
  )

  apollo::apollo_modelOutput(model)
  apollo::apollo_saveOutput(model)

  return(model)
}

