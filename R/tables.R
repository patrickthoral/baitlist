#' Create Criteria table
#'
#' Displays the criteria and associated levels used in the discrete choice experiment. Saves
#' the pivot table as `data/tables/criteria.csv`.
#' @return
#' Tibble containing criteria
#' @export
#'
#' @examples
#' criteria_table()
criteria_table <- function() {
  model_criteria <- readxl::read_excel('./data/model_criteria.xlsx')

  criteria_table <- model_criteria %>%
    tidyr::pivot_wider(
      names_from = Level,
      values_from = Description
      ) %>%
    dplyr::rename(
      "Criterion" = "Name",
      "Level 1" = "0",
      "Level 2" = "1",
      "Level 3" = "2",
      "Level 4" = "3"
    ) %>%
    dplyr::select(!(c(ID, ID_Alternative)))


  # save table to disk
  write.csv(criteria_table, paste0(
    "data/tables/", "table_criteria.csv"),
    row.names = FALSE
  )
  return(criteria_table)

}
