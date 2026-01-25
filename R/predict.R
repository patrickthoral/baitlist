#' Predict choice based on patient characteristics and family values
#'
#' Use the `apollo` package to predict the choice based on the fitted models
#' @param expected_los
#' Expected additional ICU length of stay.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | A couple of weeks |
#' | 1 | A couple of months |
#' @param clinical_situation
#' Clinical Situation.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | Deterioration |
#' | 1 | No improvement |
#' @param age
#' Age.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | 40 years |
#' | 1 | 55 years |
#' | 2 | 70 years |
#' | 3 | 85 years |
#' @param frailty
#' Frailty at hospital admission.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | Clinical Frailty Score: 1-2 |
#' | 1 | Clinical Frailty Score: 3-4 |
#' | 2 | Clinical Frailty Score: 5-6 |
#' @param life_expectancy
#' Life expectancy (pre-admission).
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | 6 - 12 months |
#' | 1 | 1 - 5 years |
#' | 1 | > 5 years |
#' @param suffering
#' Burden of Suffering.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | Limited |
#' | 1 | Severe |
#' @param disability_cardiovascular
#' Expected cardiovascular impairment after discharge.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | NYHA I |
#' | 1 | NYHA II |
#' | 2 | NYHA III |
#' | 3 | NYHA IV |
#' @param disability_pulmonary
#' Expected pulmonary impairment after discharge.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | No impairment |
#' | 1 | Moderate impairment |
#' | 2 | Severe impairment |
#' @param disability_renal
#' Expected renal impairment after discharge.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | No impairment (GFR > 30) |
#' | 1 | Pre-dialysis (GFR 15-30) |
#' | 2 | Dialysis dependent (GFR < 15) |
#' @param disability_neurological
#' Expected neurological impairment after discharge.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | mRS 0-1 |
#' | 1 | mRS 2-3 |
#' | 2 | mRS 4-5 |
#' @param disability_gastrointestinal
#' Expected gastrointestinal impairment after discharge.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | Without tube-feeding |
#' | 1 | Tube-feeding dependent |
#' @param family_values
#' Patient or Family Values.
#' Use one of the following (Default = 0):
#' | Value | Description |
#' | --- | --- |
#' | 0 | Expected future physical disabilities are possibly acceptable |
#' | 1 | Expected future physical disabilities are most likely unacceptable |
#' @param type
#' Either "binary" or "multinomial". Default: "binary".
#' @param group
#' Either "aggregate", "aumc", "olvg", "intensivists" or "fellows". Default: "aggregate"
#'
#' @return
#' Returns tibble containing the prediction.
#' @export
#'
#' @examples
#' predict(family_values = 1)
#' predict(type = "multinomial", expected_los = 1, clinical_situation = 1, age = 1, frailty = 1, life_expectancy = 1, suffering = 1, disability_cardiovascular = 1, disability_pulmonary = 1, disability_renal = 1, disability_neurological = 1, disability_gastrointestinal = 1, family_values = 1)
predict <- function(
    expected_los = 0,
    clinical_situation = 0,
    age = 0,
    frailty = 0,
    life_expectancy = 0,
    suffering = 0,
    disability_cardiovascular = 0,
    disability_pulmonary = 0,
    disability_renal = 0,
    disability_neurological = 0,
    disability_gastrointestinal = 0,
    family_values = 0,
    type = "binary",
    group = "aggregate"
) {

  library(apollo)

  # creates a dummy 'database' for apollo prediction
  database <- dplyr::tibble(
    ID=1,
    CHOICE_MULTINOMIAL=-1,
    CHOICE_BINARY=-1,
    expected_los = expected_los,
    clinical_situation = clinical_situation,
    age = age,
    frailty = frailty,
    life_expectancy = life_expectancy,
    suffering = suffering,
    disability_cardiovascular = disability_cardiovascular,
    disability_pulmonary = disability_pulmonary,
    disability_renal = disability_renal,
    disability_neurological = disability_neurological,
    disability_gastrointestinal = disability_gastrointestinal,
    family_values = family_values
  )

  # loads the select model
  if(!(type == 'binary' | type == 'multinomial')) {
    stop("Invalid model type: '", type, "'")
  }
  model <- readRDS(
    fs::path_package(
      "extdata", "apollo", type, paste0("baitlist_", group, "_model.rds"),
      package = "baitlist")
    )

  apollo_beta = model$apollo_beta
  apollo_fixed = model$apollo_fixed
  apollo_control = model$apollo_control
  apollo_probabilities = model$apollo_probabilities

  # prevent errors from single observation in tibble
  apollo_control$panelData <- FALSE

  apollo_inputs <- apollo_validateInputs(
      database = database,
      apollo_beta = apollo_beta,
      apollo_fixed = apollo_fixed,
      apollo_control = apollo_control,
      silent = TRUE)

  prediction_settings <- list(silent = TRUE)

  predictions <- apollo_prediction(
    model,
    apollo_probabilities,
    apollo_inputs,
    prediction_settings
    )

  if(type == 'binary') {
    return(predictions[c('withdraw','continue')])
  }
  else {
    return(predictions[c('withdraw','timelimited', 'continue')])
  }
}


