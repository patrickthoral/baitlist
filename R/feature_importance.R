#' Calculate feature importance using standardized coefficients
#'
#' Calculates feature importance of the binary BAIT models using standardized coefficients
#' (\eqn{\beta ^{\ast }={\frac {s_{x}}{s_{y}}}\beta}) as percentage of total.
#' Feature importance is saved for each model as csv files in the `data` folder.
#' @export
#'
#' @examples
#' standardized_coefficients()
standardized_coefficients <- function() {
  groups <- list(
    'aggregate' = 'All respondents',
    'aumc' ='Amsterdam UMC',
    'olvg'= 'OLVG',
    'intensivists' = 'Intensivists',
    'fellows' = 'Fellows'
  )

  for(group in names(groups)) {
    cat(paste0("Calculating feature importance for: ", groups[group],"\n"))

    model <- readRDS(fs::path_package("extdata/apollo/binary", paste0("baitlist_", group, "_model.rds"),
                                      package = "baitlist"))

    coefficients <- model$estimate

    data <- baitlist::load_responses(group)

    coef_names <- character()
    coef_values <- double()
    variable_names <- character()
    sd_x <- double()
    sd_y <- double()

    for(coef_name in names(coefficients)) {
      name_split <- strsplit(coef_name, split="b_")[[1]]
      if(length(name_split) > 1) {

        coef_names <- append(coef_names, coef_name)
        coef_values <- append(coef_values, coefficients[coef_name])

        variable_name <- name_split[[2]]
        variable_names <- append(variable_names, variable_name)
        sd_x <- append(sd_x, sd(data[[variable_name]]))
        sd_y <- append(sd_y, sd(data[['CHOICE_BINARY']]))

      }
    }

    tbl_coefficients <-  dplyr::tibble(coefficient_name=coef_names,
           coef=coef_values,
           variable=variable_names,
           sd_x=sd_x,
           sd_y=sd_y,
           std_coef=(sd_x/sd_y)*coef_values,
    )

    tbl_coefficients <- tbl_coefficients %>%
      dplyr::mutate(
        importance_pct=100*abs(std_coef)/sum(abs(std_coef))
        )

    # print feature importance to console
    print(tbl_coefficients)


    # save feature importance to disk
    write.csv(tbl_coefficients,
              fs::path_package(
                "extdata/feature_importance/standardized_coefficients/binary", paste0(group, ".csv"),
                package = "baitlist"),
              row.names = FALSE
              )

    cat("\n\n")

  }

}

#' Calculate relative importance using maximum utility contribution.
#'
#' Maximum Utility Contribution is calculated by multiplying the criteria level range
#' (difference between the highest and lowest level) with the absolute value of the
#' criterion weight. To calculate a percentage, the maximum utility contributions
#' are summed.
#' @export
#'
#' @examples
#' maximum_utility_contribution()
maximum_utility_contribution <- function() {
  groups <- list(
    'aggregate' = 'All respondents',
    'aumc' ='Amsterdam UMC',
    'olvg'= 'OLVG',
    'intensivists' = 'Intensivists',
    'fellows' = 'Fellows'
  )

  for(group in names(groups)) {
    cat(paste0("Calculating relative importance using maximum utility contribution for: ",
               groups[group],"\n"))

    model <- readRDS(fs::path_package(
      "extdata/apollo/binary", paste0("baitlist_", group, "_model.rds"),
      package = "baitlist")
      )

    coefficients <- model$estimate

    data <- baitlist::load_responses(group)

    coef_names <- character()
    coef_values <- double()
    variable_names <- character()
    mucs <- double()

    for(coef_name in names(coefficients)) {
      name_split <- strsplit(coef_name, split="b_")[[1]]
      if(length(name_split) > 1) {

        coef_names <- append(coef_names, coef_name)
        coef_values <- append(coef_values, coefficients[coef_name])

        variable_name <- name_split[[2]]
        variable_names <- append(variable_names, variable_name)


        # calculate maximum utility contribution
        min_x <- min(data[[variable_name]])
        max_x <- max(data[[variable_name]])
        coef_weight <- coefficients[coef_name]
        muc <- (max_x - min_x)*abs(coef_weight)

        mucs <- append(mucs, muc)
      }
    }

    tbl_coefficients <-  dplyr::tibble(coefficient_name=coef_names,
                                       coef=coef_values,
                                       variable=variable_names,
                                       max_util_contrib=mucs
    )

    tbl_coefficients <- tbl_coefficients %>%
      dplyr::mutate(
        importance_pct=100*max_util_contrib/sum(max_util_contrib)
      )

    # print feature importance to console
    print(tbl_coefficients)

    # save feature importance to disk
    write.csv(tbl_coefficients,
              fs::path_package(
                "extdata/feature_importance/maximum_utility_contribution/binary/", paste0(group, ".csv"),
                package = "baitlist"),
              row.names = FALSE
    )

    cat("\n\n")

  }

}
