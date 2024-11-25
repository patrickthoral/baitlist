#' Create Criteria table
#'
#' Displays the criteria and associated levels used in the discrete choice experiment. Saves
#' the pivot table as `data/tables/table_criteria.csv`.
#' @return
#' Tibble containing criteria
#' @export
#'
#' @examples
#' create_criteria_table()
create_criteria_table <- function() {
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

#' Create Model Weights tables
#'
#' Displays the model weights, constant, Null log-likelihood and estimated model log-likelihood and
#' adjusted rho-squared of the different models. Saves the table as `data/tables/model_weights_<.csv`.
#' @return
#' gt table of last model
#' @export
#'
#' @examples
#' create_model_weights_tables()
create_model_weights_tables <- function() {

  groups <- c(
    'aggregate' = "Aggregate",
    'aumc' = "Amsterdam UMC",
    'olvg' = "OLVG",
    'intensivists' = "Intensivists",
    'fellows' = "Fellows"
  )

  # create a vectorized version of function to allow using in dplyr functions
  coefficient_to_variable_V <- Vectorize(coefficient_to_variable)

  for(group in names(groups)) {

    model <- readRDS(paste0(
      "data/apollo/binary/",
      "baitlist_", group, "_model.rds"))

    wald <- read.csv(paste0(
      "./data/apollo/binary/",
      "baitlist_", group, "_weights_wald.csv")
    )

    # add human readable names to data set
    criteria <- readxl::read_excel(paste0(
      './data/', 'model_criteria.xlsx')
    ) %>%
      dplyr::select(ID_Alternative, Name) %>%
      dplyr::distinct() %>%
      dplyr::rename(
        "variable" = "ID_Alternative",
        "name" = "Name"
      )

    # determine variable name (e.g. strip "b_" from name)
    wald <- wald %>%
      dplyr::mutate(variable = coefficient_to_variable_V(coefficient_name)) %>%
      dplyr::mutate_at("variable", as.character)

    # remove un-estimated constant(s)
    wald <- wald %>%
      dplyr::filter(!(
        str_detect(coefficient_name, "^asc_") &
        weight == 0
        )
      )

    # join with criteria
    wald <- wald %>%
      dplyr::left_join(
        criteria,
        by = dplyr::join_by(variable)
      ) %>%
      dplyr::mutate(
        name = case_when(
          str_detect(coefficient_name, "^asc_") ~ "Constant",
          .default = name,
        ),
        type = case_when(
          str_detect(coefficient_name, "^asc_") ~ "Constant",
          .default = "Criteria"
        )
      )

    wald <- wald %>%
      tibble::add_row(
        name = "Null log-likelihood",
        type = "Goodness of Fit",
        weight = NA,
        p_value = model$LL0[[1]]
      ) %>%
      tibble::add_row(
        name = "Log-likelihood of estimated model",
        type = "Goodness of Fit",
        weight = NA,
        p_value = model$LLout[[1]]
      ) %>%
      tibble::add_row(
        name = "Adjusted $$\\rho^2$$",
        type = "Goodness of Fit",
        weight = NA,
        p_value = model$adjRho2_0[[1]]
      ) %>%
      dplyr::mutate(
        f_p_value = case_when(
          p_value < 0.0001 & p_value >= 0 ~ "< 0.0001",
          .default = formatC(p_value, digits = 3, format = "fg")
        )
      ) %>%
      dplyr::mutate(
        f_weight = formatC(weight, digits = 3, format = "fg"),
        f_robust_se = formatC(robust_se, digits = 3, format = "fg")
      ) %>%
      dplyr::mutate(
        f_weight_se =
        case_when(
          is.na(weight) ~ "",
          .default = paste0(f_weight, "<br>(", f_robust_se, ")"),
        )
      )

    table <- wald %>%
      dplyr::select(
        name,
        f_weight_se,
        f_p_value,
        type
      ) %>%
      dplyr::group_by(type) %>%
      dplyr::arrange(factor(type, levels = c("Criteria", "", "Goodness of Fit"))) %>%
      gt::gt() %>%
      gt::tab_row_group(
        label = "Goodness of Fit",
        rows = type == 'Goodness of Fit',
        id = "group_gof"
      ) %>%
      gt::tab_row_group(
        label = "",
        rows = type == 'Constant',
        id = "group_constant"
      ) %>%
      gt::tab_row_group(
        label = "",
        rows = type == 'Criteria',
        id = "group_criteria"
      ) %>%
      gt::row_group_order(
        groups = c("group_criteria", "group_constant", "group_gof")
        ) %>%
      gt::cols_align(
        align = "right",
        columns = f_p_value
      ) %>%
      gt::cols_align(
        align = "center",
        columns = f_weight_se
      ) %>%
      gt::cols_label(
        name = "Criteria",
        f_weight_se = gt::md("Weight<br>(Robust SE)"),
        f_p_value = gt::md("<i>p</i> value")
      ) %>%
      gt::tab_header(
        title = gt::md(paste0("*", groups[group], "* model"))
      ) %>%
      gt::tab_style(
        style = list(
          gt::cell_text(weight = "bold")
        ),
        location = list(
          gt::cells_column_labels(
            columns = dplyr::everything()
            ),
          gt::cells_row_groups()
        )
      ) %>%
      gt::tab_options(
        data_row.padding = gt::px(2)
        ) %>%
      gt::cols_width(
        name ~ px(400),
        everything() ~ gt::px(100)
      ) %>%
      gt::fmt_markdown()

      table %>%
        gt::gtsave(filename = paste0("./data/tables/", "model_weights_", group, ".html"))

  }

  return(table)

}

