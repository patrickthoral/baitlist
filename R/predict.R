#' Predict choice based on patient characteristics and family values
#'
#' Used the `apollo` package to predict the choice based on the fitted models
#' @param expected_los
#' Expected length of stay
#' @param clinical_situation
#' Clinical Situation
#' @param age
#' Age
#' @param frailty
#' Frailty
#' @param life_expectancy
#' Life Expectancy
#' @param suffering
#' Suffering
#' @param disability_cardiovascular
#' Expected cardiovascular disability after discharge
#' @param disability_pulmonary
#' Expected pulmonary disability after discharge
#' @param disability_renal
#' Expected renal disability after discharge
#' @param disability_neurological
#' Expected neurological disability after discharge
#' @param disability_gastrointestinal
#' Expected gastrointestinal disability after discharge
#' @param family_values
#' Family values
#' @param type
#' Either 'binary' or 'multinomial'. Default: 'binary'.
#' @param group
#' Either 'aggregate', 'aumc', 'olvg', 'intensivists' or 'fellows'. Default: 'aggregate'
#'
#' @return
#' Returns tibble containing prediction
#' @export
#'
#' @examples
#' predict(family_values = 1)
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
  model <- readRDS(paste0("data/apollo/", type, "/baitlist_", group, '_model.rds'))

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




