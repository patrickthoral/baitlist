#' Create Criteria table
#'
#' Displays the criteria and associated levels used in the discrete choice experiment. Saves
#' the pivot table as `extdata/tables/table_criteria.html`.
#' @return
#' gt table of the criteria (Table 1)
#' @export
#'
#' @examples
#' create_criteria_table()
create_criteria_table <- function() {

  # data directory
  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  model_criteria <- readxl::read_excel(
    fs::path(datadir, "model_criteria.xlsx")
  )

  criteria_table <- model_criteria %>%
    tidyr::pivot_wider(
      names_from = Level,
      values_from = Description
      ) %>%
    dplyr::rename(
      "Criterion" = "Name",
      "Level 0" = "0",
      "Level 1" = "1",
      "Level 2" = "2",
      "Level 3" = "3"
    ) %>%
    dplyr::select(!(c(ID, ID_Alternative)))

  # Build Table 1
  table <- criteria_table %>%
    # Identify impairment rows
    dplyr::mutate(
      is_impairment = grepl("impairment", Criterion, ignore.case = TRUE)
    ) %>%

    # Build gt table
    gt::gt(rowname_col = "Criterion") %>%

    # Group ONLY impairment rows, preserving original order
    gt::tab_row_group(
      label = "Baseline Clinical and Prognostic Factors",
      rows = c("Expected additional ICU length of stay",
               "Clinical situation",
               "Age (years)",
               "Frailty at hospital admission",
               "Life expectancy (pre-admission)",
               "Burden of Suffering"
      ),
      id = "general"
    ) %>%
    gt::tab_row_group(
      label = "Expected Post-ICU Impairment",
      rows = is_impairment,
      id   = "expected_impairment"
    ) %>%
    gt::tab_row_group(
      label = "Patient or Family Values",
      rows = "Patient or Family Values",
      id   = "values"
    ) %>%

    # Force ungrouped rows to appear first (preserve original order)
    gt::row_group_order(
      groups = c(
      "general",
      "expected_impairment",
      "values")
      ) %>%
    # Bold headers + bold group label
    gt::tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels(everything())
    ) %>%
    gt::tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_row_groups()
    ) %>%

    # Optional: cleaner spacing
    gt::tab_options(
      table.font.size = px(14),
      data_row.padding = px(6),
      row_group.as_column = FALSE
    ) %>%

    # Hide helper column
    gt::cols_hide("is_impairment") %>%
    gt::sub_missing(
      columns = everything(),
      missing_text = ""
      )

  table %>%
    gt::gtsave(filename = fs::path(datadir, "tables", "table_criteria.html")
    )
  return(table)

}

#' Create Model Weights tables
#'
#' Displays the model weights, constant, Null log-likelihood and estimated model log-likelihood and
#' adjusted rho-squared of the different models. Saves the table as `data/tables/model_weights_<group>.html` using the
#' gt package.
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

    model <- readRDS(
      fs::path_package(
        "extdata", "apollo", "binary", paste0("baitlist_", group, "_model.rds"),
        package = "baitlist")
    )

    wald <- read.csv(
      fs::path_package(
        "extdata", "apollo", "binary", paste0("baitlist_", group, "_weights_wald.csv"),
        package = "baitlist")
    )

    # add human readable names to data set
    criteria <- readxl::read_excel(
      fs::path_package(
        "extdata", "model_criteria.xlsx",
        package = "baitlist"
      )
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
        stringr::str_detect(coefficient_name, "^asc_") &
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
        name = dplyr::case_when(
          stringr::str_detect(coefficient_name, "^asc_") ~ "Constant",
          .default = name,
        ),
        type = dplyr::case_when(
          stringr::str_detect(coefficient_name, "^asc_") ~ "Constant",
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
        f_p_value = dplyr::case_when(
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
          dplyr::case_when(
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
        gt::gtsave(filename = fs::path_package(
          "extdata", "tables", paste0("model_weights_", group, ".html"),
          package = "baitlist")
        )

  }

  return(table)

}

#' Create group comparison table
#'
#' Creates table comparing coefficients weights with both groups using the Wald test.
#' Saves the table as `data/tables/table_group_comparison.html`.
#' @return
#' gt table
#' @export
#'
#' @examples
#' create_group_comparison_table()
create_group_comparison_table <- function() {

  comparisons <- list(
    'Amsterdam UMC vs. OLVG'=list(
      groups = c('aumc','olvg')
    ),
    'Intensivists vs. Fellows'=list(
      groups = c('intensivists','fellows')
    )
  )

  # create a vectorized version of function to allow using in dplyr functions
  coefficient_to_variable_V <- Vectorize(coefficient_to_variable)

  df_wald <- tibble::tibble()

  for(title in names(comparisons)) {
    comparison <- comparisons[[title]]
    groups <- comparison[['groups']]
    group1 <- groups[[1]]
    group2 <- groups[[2]]
    group_col <- paste(groups, collapse="_")

    group1_name <- strsplit(title, split=" vs. ")[[1]][[1]]
    group2_name <- strsplit(title, split=" vs. ")[[1]][[2]]

    wald <- read.csv(
      fs::path_package(
        "extdata", "wald", paste0(paste(groups, collapse="-"), ".csv"),
        package = "baitlist")
    )

    # determine variable name (e.g. strip "b_" from name)
    wald <- wald %>%
      dplyr::mutate(variable = coefficient_to_variable_V(coefficient_name)) %>%
      dplyr::mutate_at("variable", as.character)

    # add human readable names to data set
    criteria <- readxl::read_excel(
      fs::path_package(
        "extdata", "model_criteria.xlsx",
        package = "baitlist")
    ) %>%
      dplyr::select(ID_Alternative, Name) %>%
      dplyr::distinct() %>%
      dplyr::rename(
        "variable" = "ID_Alternative",
        "name" = "Name"
      )

    # remove un-estimated constant(s)
    wald <- wald %>%
      dplyr::filter(!(
        stringr::str_detect(coefficient_name, "^asc_") &
          is.na(wald)
      )
      )

    # join with criteria
    wald <- wald %>%
      dplyr::left_join(
        criteria,
        by = dplyr::join_by(variable)
      ) %>%
      dplyr::mutate(
        name = dplyr::case_when(
          stringr::str_detect(coefficient_name, "^asc_") ~ "Constant",
          .default = name,
        ),
        type = dplyr::case_when(
          stringr::str_detect(coefficient_name, "^asc_") ~ "Constant",
          .default = "Criteria"
        )
      )

    # add significance annotation and formatting
    wald <- wald %>%
      dplyr::mutate(
        annotation = dplyr::case_when(
          p_value < 0.001 ~ '***',
          p_value < 0.01 ~ '**',
          p_value < 0.05 ~ '*',
          .default = NA
        )
      ) %>%
      dplyr::mutate(
        f_p_value = dplyr::case_when(
          p_value < 0.0001 & p_value >= 0 ~ "< 0.0001",
          .default = formatC(p_value, digits = 3, format = "fg")
        )
      ) %>%
        dplyr::mutate(
          f_wald = formatC(wald, digits = 3, format = "fg"),
          group_col = group_col
        )

    # only keep needed columns
    wald <- wald %>%
      dplyr::select(
        name,
        f_wald,  # use pre-formatted columns
        f_p_value, # use pre-formatted columns
        annotation,
        type,
        group_col
      )

    # merge/concatenate tibbles
    df_wald <- df_wald %>%
      dplyr::bind_rows(wald)
  }

  df_wald <- df_wald %>%
    tidyr::pivot_wider(
      names_from = c("group_col"),
      names_sep = ":",
      values_from = c("f_wald", "f_p_value", "annotation")
    )

  table <- df_wald %>%
    dplyr::group_by(type) %>%
    dplyr::arrange(factor(type, levels = c("Criteria", "Constant"))) %>%
    gt::gt() %>%
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
      groups = c("group_criteria", "group_constant")
    ) %>%
    gt::cols_align(
      align = "right",
      columns = gt::starts_with("f_p_value")
    ) %>%
    gt::cols_align(
      align = "center",
      columns = gt::starts_with("f_wald")
    ) %>%
    gt::cols_label(
      name = "Criteria",
      gt::starts_with("f_wald") ~ gt::md("Wald statistic"),
      gt::starts_with("f_p_value") ~ gt::md("<i>p</i> value")
    ) %>%
    # DOES NOT function correctly: use formatting in tibble before feeding to gt
    # gt::fmt_number(decimals = 3, drop_trailing_zeros = TRUE, columns = c(wald, p_value)) %>%
    gt::tab_header(
      title = gt::md(paste0("**Subgroup comparison**"))
    ) %>%
    gt::opt_align_table_header(align = "left") %>%
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
    )

  # create spanners for each comparison
  for(title in names(comparisons)) {
    comparison <- comparisons[[title]]
    groups <- comparison[['groups']]
    group_col <- paste(groups, collapse="_")

    table <- table %>%
      gt::tab_spanner(
        id = paste0("spanner_", group_col),
        label = title,
        columns = gt::ends_with(group_col)
      ) %>%
      # add asterisks to Wald if significant
      gt::cols_merge(
        columns = c(paste0("f_wald:", group_col), paste0("annotation:", group_col)),
        pattern = "{1}<<{2}>>"
      )
  }

  # create significance footnote based on actual annotations
  annotations <- df_wald %>%
    dplyr::select(dplyr::starts_with("annotation"))

  footnotes_needed <- c()
  for(col in colnames(annotations)) {
    footnotes_needed <- c(
      footnotes_needed,
      annotations[col] %>%
        tidyr::drop_na() %>%
        unique() %>%
        dplyr::pull()

    )
  }

  footnotes_needed <- unique(footnotes_needed)
  footnotes <- c()
  if("*" %in% footnotes_needed) {
    footnotes <- c(footnotes, "&ast; *p* < 0.05")
  }
  if("**" %in% footnotes_needed) {
    footnotes <- c(footnotes, "&ast;&ast; *p* < 0.01")
  }
  if("***" %in% footnotes_needed) {
    footnotes <- c(footnotes, "&ast;&ast;&ast; *p* < 0.001")
  }

  # add footnotes to table and set column widths
  table <- table %>%
    gt::tab_options(
      data_row.padding = gt::px(2)
    ) %>%
    gt::cols_width(
      name ~ px(400),
      everything() ~ gt::px(100)
    ) %>%
    gt::tab_footnote(
      footnote = gt::md(paste(footnotes, collapse = "; "))
      )

  table %>%
    gt::gtsave(filename = fs::path_package(
      "extdata", "tables", "table_group_comparison.html",
      package = "baitlist")
    )

  return(table)
}
