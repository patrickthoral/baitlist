select_groups <- function(group = "aggregate") {
  database <- readxl::read_excel(
    fs::path_package(
      "extdata", "responses.xlsx",
      package = "baitlist")
    )

  if(group == 'aumc') {
    database <- database %>%
      dplyr::filter(.data[["Bij welke instantie bent u werkzaam?"]] == "Amsterdam UMC")
  } else if(group == 'olvg') {
    database <- database %>%
      dplyr::filter(.data[["Bij welke instantie bent u werkzaam?"]] == "OLVG")
  } else if(group == 'intensivists') {
    database <- database %>%
      dplyr::filter(.data[["Functie niveau"]] == "Intensivist")
  } else if(group == 'fellows') {
    database <- database %>%
      dplyr::filter(.data[["Functie niveau"]] == "Fellow")
  }

  return(database)
}

#' Load responses
#' Reads data from the data/responses.xlsx file for specific groups or all if not specified.
#' @param group The group to filter the data on.
#' Valid values: 'aumc', 'olvg', 'intensivists', 'fellows'. If omitted all responses are returned.
#'
#' @return data.frame (tibble) containing responses for the specified group
#' @export
#'
#' @examples
#' data_fellows <- load_responses('fellows')
#'
load_responses <- function(group = "aggregate") {

  if(missing(group)) {
    group <- 'aggregate'
  }

  database <- select_groups(group)

  # add (missing) dummy columns

  database <- database %>%
    dplyr::mutate(
      c_dummy3 = dplyr::case_when( c == 3 ~ 1, .default = 0),
      d_dummy2 = dplyr::case_when( d == 2 ~ 1, .default = 0),
      e_dummy2 = dplyr::case_when( e == 2 ~ 1, .default = 0),
      g_dummy3 = dplyr::case_when( g == 3 ~ 1, .default = 0),
      h_dummy2 = dplyr::case_when( h == 2 ~ 1, .default = 0),
      i_dummy2 = dplyr::case_when( i == 2 ~ 1, .default = 0),
      j_dummy2 = dplyr::case_when( j == 2 ~ 1, .default = 0)
    )

  database <- database %>%
    dplyr::rename("expected_los" = "a",
           "clinical_situation" = "b",
           "age" = "c",
           "age0" = "c_dummy0",
           "age1" = "c_dummy1",
           "age2" = "c_dummy2",
           "age3" = "c_dummy3",
           "frailty" = "d",
           "frailty0" = "d_dummy0",
           "frailty1" = "d_dummy1",
           "frailty2" = "d_dummy2",
           "life_expectancy" = "e",
           "life_expectancy0" = "e_dummy0",
           "life_expectancy1" = "e_dummy1",
           "life_expectancy2" = "e_dummy2",
           "suffering" = "f",
           "disability_cardiovascular" = "g",
           "disability_cardiovascular0" = "g_dummy0",
           "disability_cardiovascular1" = "g_dummy1",
           "disability_cardiovascular2" = "g_dummy2",
           "disability_cardiovascular3" = "g_dummy3",
           "disability_pulmonary" = "h",
           "disability_pulmonary0" = "h_dummy0",
           "disability_pulmonary1" = "h_dummy1",
           "disability_pulmonary2" = "h_dummy2",
           "disability_renal" = "i",
           "disability_renal0" = "i_dummy0",
           "disability_renal1" = "i_dummy1",
           "disability_renal2" = "i_dummy2",
           "disability_neurological" = "j",
           "disability_neurological0" = "j_dummy0",
           "disability_neurological1" = "j_dummy1",
           "disability_neurological2" = "j_dummy2",
           "disability_gastrointestinal" = "k",
           "family_values" = "l"
    )

  # create availability columns, since every factor is only used for a single decision
  database <- database %>%
    dplyr::mutate(
      avail_withdraw = dplyr::case_when( CHOICE_BINARY == 0 ~ 1, .default = 0),
      avail_continue = dplyr::case_when( CHOICE_BINARY == 1 ~ 1, .default = 0)
    )

  return(database)
}
