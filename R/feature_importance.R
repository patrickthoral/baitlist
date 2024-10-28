#' Calculate feature importance
#'
#' Calculates feature importance of the binary BAIT models using standardized coefficients
#' (\eqn{\beta ^{\ast }={\frac {s_{x}}{s_{y}}}\beta}) as percentage of total.
#' Feature importance is saved for each model as csv files in the `data` folder.
#' @export
#'
#' @examples
#' feature_importance_binary()
feature_importance_binary <- function() {
  groups <- list(
    'aggregate' = 'All respondents',
    'aumc' ='Amsterdam UMC',
    'olvg'= 'OLVG',
    'intensivists' = 'Intensivists',
    'fellows' = 'Fellows'
  )

  for(group in names(groups)) {
    cat(paste0("Calculating feature importance for: ", groups[group],"\n"))

    model <- readRDS(paste0('data/apollo/binary/baitlist_', group, '_model.rds'))

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
    write.csv(tbl_coefficients, paste0(
      "./data/feature_importance/binary/", group, ".csv"),
      row.names = FALSE
    )

    cat("\n\n")

  }

}
