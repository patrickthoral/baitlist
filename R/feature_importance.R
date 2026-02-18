#' Calculates feature importance for all BAIT model types and groups using
#' standardized coefficients and maximum utility contribution.
#'
#' Standardized Coefficients (\eqn{\beta ^{\ast }={\frac {s_{x}}{s_{y}}}\beta}) as
#' percentage of total.
#'
#' Maximum Utility Contribution is calculated by multiplying the criteria level range
#' (difference between the highest and lowest level) with the absolute value of the
#' criterion weight. To calculate a percentage, the maximum utility contributions
#' are summed.
#'
#' Feature importance is saved for each model as csv files in the `inst/extdata` folder.
#' @export
#'
#' @examples
#' baitlist::feature_importance_all()
feature_importance_all <- function() {

  groups <- list(
    'aggregate' = 'All respondents',
    'aumc' ='Amsterdam UMC',
    'olvg'= 'OLVG',
    'intensivists' = 'Intensivists',
    'fellows' = 'Fellows'
  )

  modeltypes <- c(
    "binary", "multinomial"
  )

  methods <- list(
    "standardized_coefficients" = "Standardized Coefficients",
    "maximum_utility_contribution" = "Maximum Utility Contribution"
  )

  for(modeltype in modeltypes) {

    for(method in names(methods)) {

      for(group in names(groups)) {

        cat(paste0("Calculating feature importance using ", methods[method], " for: ", groups[group],"\n"))

        feature_importance(method, modeltype, group)

        cat("\n\n")

      } # end groups

    } # end methods

  } # end modeltypes

}

#' Calculates feature importance for all BAIT model types and groups using standardized coefficients
#' and maximum utility contribution.
#'
#' Standardized Coefficients (\eqn{\beta ^{\ast }={\frac {s_{x}}{s_{y}}}\beta}) as
#' percentage of total.
#'
#' Maximum Utility Contribution is calculated by multiplying the criteria level range
#' (difference between the highest and lowest level) with the absolute value of the
#' criterion weight. To calculate a percentage, the maximum utility contributions
#' are summed.
#'
#' Feature importance is saved for each model as csv files in the `inst/extdata` folder.
#'
#' @param method Method used for calculating feature importance. Either 'maximum_utility_contribution' or 'standardized_coefficients'
#' @param modeltype Model type. Either 'binary' or 'multinomial'
#' @param group Participant group. One of the following 'aggregate', 'aumc', 'olvg', 'intensivists', 'fellows'
#'
#' @export
#'
#' @examples
#' baitlist::feature_importance(method="maximum_utility_contribution", modeltype="multinomial", group="aggregate")
feature_importance <- function(
    method="maximum_utility_contribution",
    modeltype="binary",
    group="aggregate"
) {

  model <- readRDS(fs::path_package("extdata", "apollo", modeltype, paste0("baitlist_", group, "_model.rds"),
                                    package = "baitlist"))

  coefficients <- model$estimate

  data <- baitlist::load_responses(group)

  coef_names <- character()
  coef_values <- double()
  variable_names <- character()
  alternatives <- character()

  # standardized coefficients
  sd_x <- double()
  sd_y <- double()

  # maximum utility contribution
  mucs <- double()

  for(coef_name in names(coefficients)) {

    if(modeltype == 'binary') {
      match <- stringr::str_match(coef_name, "^b_(.*)$")
    }
    else {
      match <- stringr::str_match(coef_name, "^b_(.*)_(continue|timelimited)$")
      alternative <- match[,3]
    }
    variable_name <- match[,2]


    if(!is.na(variable_name)) {

      coef_names <- append(coef_names, coef_name)
      coef_values <- append(coef_values, coefficients[coef_name])
      variable_names <- append(variable_names, variable_name)

      if (modeltype == 'multinomial') {
        alternatives <- append(alternatives, alternative)
      }

      if(method == 'standardized_coefficients') {
        # calculate standardized coefficients
        sd_x <- append(sd_x, sd(data[[variable_name]]))
        sd_y <- append(sd_y, sd(data[['CHOICE_MULTINOMIAL']]))
      }

      else {
        # calculate maximum utility contribution
        min_x <- min(data[[variable_name]])
        max_x <- max(data[[variable_name]])
        coef_weight <- coefficients[coef_name]
        muc <- (max_x - min_x)*abs(coef_weight)
        mucs <- append(mucs, muc)
      }
    }
  }


  tbl_coefficients <-  dplyr::tibble(coefficient_name=coef_names,
                                     coef=coef_values,
                                     variable=variable_names) %>%
    dplyr::mutate(
      alternative = if (modeltype == 'multinomial') alternatives else NULL, # if column is completely NULL it will not be added
      sd_x = if (method == 'standardized_coefficients') sd_x else NULL,
      sd_y = if (method == 'standardized_coefficients') sd_y else NULL,
      std_coef = if (method == 'standardized_coefficients') (sd_x/sd_y)*coef_values else NULL,
      max_util_contrib = if (method == 'maximum_utility_contribution') mucs else NULL,
      importance_pct = if (method == 'standardized_coefficients') 100*abs(std_coef)/sum(abs(std_coef)) else 100*max_util_contrib/sum(max_util_contrib)
    )

  # print feature importance to console
  print(tbl_coefficients, n=24)

  # save feature importance to disk
  write.csv(tbl_coefficients,
            fs::path_package(
              "extdata", "feature_importance", method, modeltype, paste0(group, ".csv"),
              package = "baitlist"),
            row.names = FALSE
  )

}

#' Calculate feature importance using standardized coefficients
#'
#' Calculates feature importance of the BAIT models using standardized coefficients
#' (\eqn{\beta ^{\ast }={\frac {s_{x}}{s_{y}}}\beta}) as percentage of total.
#' Feature importance is saved for each model as csv files in the `data` folder.
#' @export
#'
#' @examples
#' standardized_coefficients()
standardized_coefficients <- function(modeltype="binary", group="aggregate") {
  feature_importance(method = "standardized_coefficients", modeltype = modeltype, group = group)
}

#' Calculate feature importance using maximum utility contribution.
#'
#' Maximum Utility Contribution is calculated by multiplying the criteria level range
#' (difference between the highest and lowest level) with the absolute value of the
#' criterion weight. To calculate a percentage, the maximum utility contributions
#' are summed.
#' @export
#'
#' @examples
#' maximum_utility_contribution()
maximum_utility_contribution <- function(modeltype="binary", group="aggregate") {
  feature_importance(method = "maximum_utility_contribution", modeltype = modeltype, group = group)
}
