#' Create Criteria table
#'
#' Displays the criteria and associated levels used in the discrete choice experiment. Saves
#' the pivot table as `extdata/tables/table_criteria.html`.
#' @return
#' gt table of the criteria (Table 1)
#' @export
#'
#' @examples
#' baitlist::create_criteria_table()
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
      style = gt::cell_text(weight = "bold"),
      locations = gt::cells_column_labels(dplyr::everything())
    ) %>%
    gt::tab_style(
      style = gt::cell_text(weight = "bold"),
      locations = gt::cells_row_groups()
    ) %>%

    # Optional: cleaner spacing
    gt::tab_options(
      table.font.size = gt::px(14),
      data_row.padding = gt::px(6),
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
#' adjusted rho-squared of the binary and multinomial models for each model separately and a large
#' combined table for across all groups of each model type.
#' Saves the tables as `extdata/tables/<binary|multinomial>/model_weights_<group>.html` using the
#' gt package.
#' @return
#' list of gt tables
#' @export
#'
#' @examples
#' tables <- baitlist::create_model_weights_tables()
#' tables$binary$aggregate
create_model_weights_tables <- function() {

  groups <- c(
    'aggregate' = "All participants",
    'aumc' = "Amsterdam UMC",
    'olvg' = "OLVG",
    'intensivists' = "Intensivists",
    'fellows' = "Fellows"
  )

  modeltypes <- c('binary', 'multinomial')

  cat("Creating model weights tables...\n")

  tables <- list()

  # data directory
  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  for(modeltype in modeltypes) {

    tables[[modeltype]] <- list()

    # store combined table
    all_wald <- list()

    for(group in names(groups)) {

      cat(paste0("Processing ", groups[group], " model (", modeltype, ")...\n"))

      model <- readRDS(
        fs::path(datadir, "apollo", modeltype, paste0("baitlist_", group, "_model.rds"))
      )

      wald <- utils::read.csv(
        fs::path(datadir, "apollo", modeltype, paste0("baitlist_", group, "_weights_wald.csv")
        )
      )

      # add human readable names to data set
      criteria <- readxl::read_excel(
        fs::path(datadir, "model_criteria.xlsx")
      ) %>%
        dplyr::select(ID_Alternative, Name) %>%
        dplyr::distinct() %>%
        dplyr::rename(
          "variable" = "ID_Alternative",
          "name" = "Name"
        )

      # determine variable name
      wald <- wald %>%
        tidyr::extract(
          col = coefficient_name,
          into = c("variable", "variable_alternative", "constant_alternative"),
          regex = "^(?:b_(.*?)(?:_(continue|timelimited))?|asc_(.*))$",
          remove = FALSE
        ) %>%
        dplyr::mutate(
          dplyr::across(
            c(variable_alternative, constant_alternative),
            ~ dplyr::na_if(.x, "")
          ),
          alternative = dplyr::coalesce(variable_alternative, constant_alternative)
        )


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

      # add criterion order to tibble
      wald <- wald %>%
        dplyr::mutate(
          .row_id = dplyr::row_number(),
          .coef_id = dplyr::coalesce(variable)
        ) %>%
        dplyr::group_by(.coef_id) %>%
        dplyr::mutate(.crit_order = min(.row_id)) %>%
        dplyr::ungroup()


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
          CI_low = weight - 1.96 * robust_se,
          CI_high = weight + 1.96 * robust_se,
          CI_95 = sprintf("[%.3f,&nbsp;%.3f]", CI_low, CI_high)
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
            ),
          f_weight_ci =
            dplyr::case_when(
              is.na(weight) ~ "",
              .default = paste0(f_weight, "<br>", CI_95),
            )
        )

      # change labels
      if (modeltype == "multinomial") {
        wald <- wald %>%
          dplyr::mutate(
            alternative = dplyr::case_match(
              alternative,
              "continue" ~ "Continue",
              "timelimited" ~ "Time-Limited",
              .default = alternative
            )
          )
      }

      # store the processed wald table for later combination
      all_wald[[group]] <- wald %>%
        dplyr::select(
          name,
          weight,
          p_value,
          dplyr::any_of(if (modeltype == "multinomial") "alternative"),
          .crit_order,
          type,
          f_weight_se,
          f_weight_ci,
          f_p_value)

      if (modeltype == "multinomial") {
        wald <- wald %>%
          dplyr::group_by(type, name) %>%
          dplyr::arrange(
            factor(type, levels = c("Criteria", "Constant", "Goodness of Fit")),
            .crit_order,
            alternative
          ) %>%
          dplyr::mutate(
            name = dplyr::if_else(
              dplyr::row_number() == 1,
              name,
              ""
            )
          ) %>%
          dplyr::ungroup()
      }

      table <- wald %>%
        dplyr::select(
          name,
          dplyr::any_of(if (modeltype == "multinomial") "alternative"),
          weight,
          f_weight_se,
          f_weight_ci,
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
          columns = c(f_weight_se, f_weight_ci)
        ) %>%
        gt::cols_label(
          name = "Criteria",
          gt::starts_with("alternative") ~ gt::md("Alternative"),
          f_weight_se = gt::md("Weight<br>(Robust SE)"),
          f_weight_ci = gt::md("Weight<br>[95% CI]"),
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
        gt::cols_hide(columns = c(weight, f_weight_se)) %>%
        gt::sub_missing(
          columns = everything(),
          missing_text = ""
        ) %>%
        gt::fmt_markdown()

      if (modeltype == 'multinomial') {
        table <- table %>%
          gt::cols_width(
            alternative ~ gt::px(150)
          ) %>%
          gt::tab_style(
            style = gt::cell_borders(
              sides = "top",
              color = "transparent",
              weight = gt::px(0)
            ),
            locations = gt::cells_body(
              rows = name == "",   # continuation rows
              columns = name
            )
          ) %>%
          gt::tab_footnote(
            footnote = gt::md("**Continue**: Continue life-sustaining therapy vs. Withdrawal"),
            locations = gt::cells_body(
              columns = "alternative",
              rows = alternative == "Continue"
            )
          ) %>%
          gt::tab_footnote(
            footnote = gt::md("**Time-Limited**: Time-Limited Trial vs. Withdrawal"),
            locations = gt::cells_body(
              columns = "alternative",
              rows = alternative == "Time-Limited"
            )
          )
      }

      # store in return list
      tables[[modeltype]][[group]] <- table

      table %>%
        gt::gtsave(
          filename = fs::path(datadir, "tables", modeltype, paste0("model_weights_", group, ".html"))
        )
    }

    # combine all groups into one table
    cat(paste0("Creating combined table across group (", modeltype, ")...\n"))
    combined_list <- list()

    for (g in names(all_wald)) {
      df <- all_wald[[g]] %>%
        dplyr::mutate(group = g)

      combined_list[[g]] <- df
    }

    # one row per (name, type), columns per group and measure
    combined <- dplyr::bind_rows(combined_list) %>%
      tidyr::pivot_wider(
        names_from  = group,
        values_from = c(weight, p_value, f_weight_se, f_weight_ci, f_p_value),
        names_glue  = "{group}_{.value}"
      )

    if (modeltype == "multinomial") {
      combined <- combined %>%
        dplyr::group_by(type, name) %>%
        dplyr::arrange(
          factor(type, levels = c("Criteria", "Constant", "Goodness of Fit")),
          .crit_order,
          alternative
        ) %>%
        dplyr::mutate(
          name = dplyr::if_else(
            dplyr::row_number() == 1,
            name,
            ""
          )
        ) %>%
        dplyr::ungroup()
    }

    combined_table <- combined %>%
      dplyr::select(-.crit_order) %>%
      # calculate style helpers
      dplyr::mutate(
        is_negative    = dplyr::if_any(dplyr::matches("_weight$"), ~ .x < 0),
        is_positive    = dplyr::if_any(dplyr::matches("_weight$"), ~ .x > 0),
        is_significant = dplyr::if_any(dplyr::matches("_p_value$"), ~ .x < 0.05)
      ) %>%
      gt::gt(
        rowname_col   = "name",
        groupname_col = "type"
        )

    # Loop over groups
    for (g in names(groups)) {

      weight_col <- rlang::sym(paste0(g, "_weight"))
      pval_col <- rlang::sym(paste0(g, "_p_value"))
      display_col <- rlang::sym(paste0(g, "_f_weight_ci"))
      alt_col <- rlang::sym("alternative")

      combined_table <- combined_table %>%
        gt::tab_spanner(
          label   = groups[[g]],
          columns = dplyr::matches(paste0("^", g, "_"))
        ) %>%
        gt::cols_align(
          align = "right",
          columns = dplyr::matches("_p_value$")
        ) %>%
        gt::cols_align(
          align = "center",
          columns = dplyr::matches("(_f_weight_se$|_f_weight_ci$)")
        ) %>%
        gt::cols_label(
          !!paste0(g, "_f_weight_se") := gt::md("Weight<br>(Robust SE)"),
          !!paste0(g, "_f_weight_ci") := gt::md("Weight<br>[95% CI]"),
          !!paste0(g, "_f_p_value")   := gt::md("<i>p</i> value")
        ) %>%

        # Negative
        gt::tab_style(
          style = gt::cell_fill(color = "#F2DEDE"),
          locations = gt::cells_body(
            columns = !!display_col,
            rows = !!weight_col < 0
          )
        ) %>%

        # Positive
        gt::tab_style(
          style = gt::cell_fill(color = "#DFF0D8"),
          locations = gt::cells_body(
            columns = !!display_col,
            rows = !!weight_col > 0
          )
        )

        # Positive: yellow for timelimited
        if (modeltype == "multinomial") {
          combined_table <- combined_table %>%
            gt::tab_style(
              style = gt::cell_fill(color = "#FFF4C2"),
              locations = gt::cells_body(
                columns = !!display_col,
                rows = (!!weight_col > 0) & (!!alt_col == "Time-Limited")
              )
            )
        }

      combined_table <- combined_table %>%

        # Signficant: bold
      gt::tab_style(
        style = gt::cell_text(weight = "bold"),
        locations = gt::cells_body(
          columns = !!display_col,
          rows = !!pval_col < 0.05
        )
      ) %>%

        # Hide numeric columns *after* styling
        gt::cols_hide(columns = c(
          paste0(g, "_f_weight_se"),
          paste0(g, "_weight"),
          paste0(g, "_p_value")
        ))
    }

    # Yellow swatch only for multinomial
    yellow_legend <- if (modeltype == "multinomial") {
      paste0(
        "&nbsp;<span style='background-color:#FFF4C2;",
        "border:1px solid #E0D7A8;",
        "padding:2px 6px;",
        "border-radius:3px;'>Yellow</span> = Effect towards Time-Limited Trial,&nbsp;"
      )
    } else {
      ""
    }

    legend_html <- paste0(
      "<span style='background-color:#F2DEDE;",
      "border:1px solid #C8BFBF;",
      "padding:2px 6px;",
      "border-radius:3px;'>Red</span> = Effect towards Withdrawal,&nbsp;",

      yellow_legend,

      "<span style='background-color:#DFF0D8;",
      "border:1px solid #B7C8B7;",
      "padding:2px 6px;",
      "border-radius:3px;'>Green</span> = Effect towards Continue,&nbsp;",

      "<span style='font-weight:bold;'>Bold</span> = *p* < 0.05"
    )


    combined_table <- combined_table %>%
      gt::opt_row_striping() %>%
      gt::tab_source_note(
        source_note = gt::md(legend_html)
      )

    combined_table <- combined_table %>%
      gt::cols_hide(columns = c(
        "is_negative",
        "is_positive",
        "is_significant"
        ))

    combined_table <- combined_table %>%
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
        label = "Criteria",
        rows = type == 'Criteria',
        id = "group_criteria"
      ) %>%
      gt::row_group_order(
        groups = c("group_criteria", "group_constant", "group_gof")
      ) %>%
      gt::tab_header(
        title = gt::md("Model Weights Across All Groups")
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
      gt::cols_label(
        name = "Criteria",
        gt::starts_with("alternative") ~ gt::md("Alternative")
        ) %>%
      gt::sub_missing(
        columns = everything(),
        missing_text = ""
      ) %>%
      gt::fmt_markdown()

    if (modeltype == 'multinomial') {
      combined_table <- combined_table %>%
        gt::cols_width(
          alternative ~ gt::px(150)
        ) %>%
        gt::tab_footnote(
          footnote = gt::md("**Continue**: Continue life-sustaining therapy vs. Withdrawal"),
          locations = gt::cells_body(
            columns = "alternative",
            rows = alternative == "Continue"
          )
        ) %>%
        gt::tab_footnote(
          footnote = gt::md("**Time-Limited**: Time-Limited Trial vs. Withdrawal"),
          locations = gt::cells_body(
            columns = "alternative",
            rows = alternative == "Time-Limited"
          )
        )
    }

    # store in return list
    group <- "across_groups"
    tables[[modeltype]][[group]] <- combined_table

    combined_table %>%
      gt::gtsave(
        filename = fs::path(datadir, "tables", modeltype, paste0("model_weights_", group, ".html"))
      )

  }

  cat("Done.\n")
  return(tables)

}

#' Create group comparison table
#'
#' Creates tables for both the binary and multinomial models comparing
#' coefficients weights with both groups using the Wald test.
#' Saves the table as `data/tables/table_group_comparison.html`.
#' @return
#' list of gt tables
#' @export
#'
#' @examples
#' tables <- baitlist::create_group_comparison_tables()
#' tables$binary
create_group_comparison_tables <- function() {

  comparisons <- list(
    'Amsterdam UMC vs. OLVG'=list(
      groups = c('aumc','olvg')
    ),
    'Intensivists vs. Fellows'=list(
      groups = c('intensivists','fellows')
    )
  )

  modeltypes <- c('binary', 'multinomial')

  tables <- list()

  # data directory
  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  for(modeltype in modeltypes) {

    df_wald <- tibble::tibble()

    for(title in names(comparisons)) {
      comparison <- comparisons[[title]]
      groups <- comparison[['groups']]
      group1 <- groups[[1]]
      group2 <- groups[[2]]
      group_col <- paste(groups, collapse="_")

      group1_name <- strsplit(title, split=" vs. ")[[1]][[1]]
      group2_name <- strsplit(title, split=" vs. ")[[1]][[2]]

      wald <- utils::read.csv(
        fs::path(datadir, "wald", modeltype, paste0(paste(groups, collapse="-"), ".csv"))
      )

      # determine variable name
      wald <- wald %>%
        tidyr::extract(
          col = coefficient_name,
          into = c("variable", "variable_alternative", "constant_alternative"),
          regex = "^(?:b_(.*?)(?:_(continue|timelimited))?|asc_(.*))$",
          remove = FALSE
        ) %>%
        dplyr::mutate(
          dplyr::across( # set to NA if ""
            c(variable_alternative, constant_alternative), ~ dplyr::na_if(.x, "")
            ),
          alternative = dplyr::coalesce(variable_alternative, constant_alternative)
          )

      # add human readable names to data set
      criteria <- readxl::read_excel(
        fs::path(datadir, "model_criteria.xlsx")
      ) %>%
        dplyr::select(ID_Alternative, Name) %>%
        dplyr::distinct() %>%
        dplyr::rename(
          "variable" = "ID_Alternative",
          "name" = "Name"
        )

      # remove un-estimated constant(s)
      wald <- wald %>%
        dplyr::filter(
          !(stringr::str_detect(coefficient_name, "^asc_") & is.na(wald))
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
      cols <- c(
        "name",
        if(modeltype == 'multinomial') "alternative",
        "f_wald",  # use pre-formatted columns
        "f_p_value", # use pre-formatted columns
        "annotation",
        "type",
        "group_col"
      )

      wald <- wald %>%
        dplyr::select(cols)

      # merge/concatenate tibbles
      df_wald <- df_wald %>%
        dplyr::bind_rows(wald)
    }

    ids_cols <- c("name", "type", if(modeltype == 'multinomial') "alternative")

    df_wald <- df_wald %>%
      tidyr::pivot_wider(
        names_from = c("group_col"),
        names_sep = ":",
        values_from = c("f_wald", "f_p_value", "annotation"),
        id_cols = c(ids_cols)
      )

    # create 'fake' row spanners since gt does not support them
    if (modeltype == "multinomial") {
      df_wald <- df_wald %>%
        dplyr::mutate(
          alternative = dplyr::case_match(
            alternative,
            "continue" ~ "Continue",
            "timelimited" ~ "Time-Limited",
            .default = alternative
          )
        ) %>%
        dplyr::group_by(type, name) %>%
        dplyr::arrange(factor(type, levels = c("Criteria", "Constant")), name, alternative) %>%
        dplyr::mutate(
          name = dplyr::if_else(
            dplyr::row_number() == 1,
            name,
            ""   # hide repeated criteria labels
          )
        ) %>%
        dplyr::ungroup()
    }
    else {
      df_wald <- df_wald %>%
        dplyr::arrange(factor(type, levels = c("Criteria", "Constant")))
    }

    table <- df_wald %>%
      gt::gt() %>%
      gt::cols_hide("type") %>%
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
        gt::starts_with("alternative") ~ gt::md("Alternative"),
        gt::starts_with("f_wald") ~ gt::md("Wald statistic"),
        gt::starts_with("f_p_value") ~ gt::md("<i>p</i> value")
      ) %>%
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
        ) %>%
      gt::tab_style(
        style = gt::cell_borders(
          sides = "top",
          color = "transparent",
          weight = gt::px(0)
        ),
        locations = gt::cells_body(
          rows = name == "",   # continuation rows
          columns = name
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

    if ("alternative" %in% colnames(df_wald)) {
      table <- table %>%
        gt::cols_width(
          alternative ~ px(150)
        ) %>%
        gt::tab_footnote(
          footnote = gt::md("**Continue**: Continue life-sustaining therapy vs. Withdrawal"),
          locations = gt::cells_body(
            columns = "alternative",
            rows = alternative == "Continue"
          )
        ) %>%
        gt::tab_footnote(
          footnote = gt::md("**Time-Limited**: Time-Limited Trial vs. Withdrawal"),
          locations = gt::cells_body(
            columns = "alternative",
            rows = alternative == "Time-Limited"
          )
        )
    }

    table %>%
      gt::gtsave(filename = fs::path(datadir, "tables", modeltype, "table_group_comparison.html")
      )

    tables[[modeltype]] <- table
  }

  return(tables)
}

#' Create pooled group comparison table (interaction models)
#'
#' Uses pooled Apollo models with group interaction terms (d_*) to compare
#' coefficients between subgroups for both binary and multinomial models.
#'
#' @return list of gt tables (binary and multinomial)
#' @export
#'
#' @examples
#' tables <- baitlist::create_pooled_group_comparison_tables()
#' tables$binary
create_pooled_group_comparison_tables <- function() {

  comparisons <- list(
    "Amsterdam UMC vs. OLVG" = list(
      groups = c("aumc", "olvg")
    ),
    "Intensivists vs. Fellows" = list(
      groups = c("intensivists", "fellows")
    )
  )

  modeltypes <- c("binary", "multinomial")

  tables <- list()

  datadir <- fs::path_package("extdata", package = "baitlist")

  for (modeltype in modeltypes) {

    df_wald <- tibble::tibble()

    for (title in names(comparisons)) {

      comparison <- comparisons[[title]]
      groups     <- comparison[["groups"]]
      group1     <- groups[[1]]
      group2     <- groups[[2]]
      group_col  <- paste(groups, collapse = "_")

      group1_name <- strsplit(title, split = " vs. ")[[1]][[1]]
      group2_name <- strsplit(title, split = " vs. ")[[1]][[2]]

      wald <- wald_interaction(group1, group2, modeltype)
      df_wald <- df_wald %>%
        dplyr::bind_rows(wald)
    }

    # Pivot wider to get one column per comparison
    ids_cols <- c("name", "type", if (modeltype == "multinomial") "alternative")

    df_wald <- df_wald %>%
      tidyr::pivot_wider(
        names_from  = c("group_col"),
        names_sep   = ":",
        values_from = c("f_wald", "f_p_raw", "f_p_value", "annotation"),
        id_cols     = c(dplyr::all_of(ids_cols))
      )

    # Fake row spanners and ordering
    if (modeltype == "multinomial") {
      df_wald <- df_wald %>%
        # only show interactions (for multinomial duplicated)
        dplyr::filter(!(type == "Criteria" & alternative == "timelimited")) %>%
        dplyr::mutate(
          alternative = dplyr::case_match(
            alternative,
            "continue"    ~ "Continue",
            "timelimited" ~ "Time-Limited",
            .default      = alternative
          )
        ) %>%
        dplyr::mutate(
          name = dplyr::case_when(
            type == "Constant" & alternative != "" ~ paste0(name, " - ", alternative),
            TRUE ~ name
          )
        ) %>%
        dplyr::group_by(type, name) %>%
        dplyr::arrange(
          factor(type, levels = c("Joint Test", "Criteria", "Constant")),
          alternative
        ) %>%
        dplyr::mutate(
          name = dplyr::if_else(
            dplyr::row_number() == 1,
            name,
            ""
          )
        ) %>%
        dplyr::ungroup()
    } else {
      df_wald <- df_wald %>%
        dplyr::arrange(factor(type, levels = c("Joint Test", "Criteria", "Constant")))
    }

    # Build gt table
    table <- df_wald %>%
      gt::gt() %>%
      gt::cols_hide("type") %>%
      gt::tab_row_group(
        label = "",
        rows  = type == "Constant",
        id    = "group_constant"
      ) %>%
      gt::tab_row_group(
        label = "Individual Criteria",
        rows  = type == "Criteria",
        id    = "group_criteria"
      ) %>%
      gt::tab_row_group(
        label = "",
        rows  = type == "Joint Test",
        id    = "group_joint"
      ) %>%
      gt::row_group_order(
        groups = c("group_joint", "group_criteria", "group_constant")
      ) %>%
      gt::cols_align(
        align   = "right",
        columns = c(gt::starts_with("f_p_value"), gt::starts_with("f_p_raw"))
      ) %>%
      gt::cols_align(
        align   = "center",
        columns = gt::starts_with("f_wald")
      ) %>%
      gt::cols_label(
        name = "Criteria",
        gt::starts_with("alternative") ~ gt::md("Alternative"),
        gt::starts_with("f_wald") ~ gt::md("Wald statistic"),
        gt::starts_with("f_p_raw") ~ gt::md("Uncorrected *p* value"),
        gt::starts_with("f_p_value") ~ gt::md("<i>p</i> value")
      ) %>%
      gt::tab_header(
        title = gt::md(paste0("**Subgroup comparison - ", modeltype, " pooled interaction models**"))
      ) %>%
      gt::opt_align_table_header(align = "left") %>%
      gt::tab_style(
        style = list(
          gt::cell_text(weight = "bold")
        ),
        location = list(
          gt::cells_column_labels(columns = dplyr::everything()),
          gt::cells_row_groups()
        )
      ) %>%
      gt::tab_style(
        style = gt::cell_borders(
          sides  = "top",
          color  = "transparent",
          weight = gt::px(0)
        ),
        locations = gt::cells_body(
          rows    = name == "",
          columns = name
        )
      )

    # Spanners per comparison
    for (title in names(comparisons)) {
      comparison <- comparisons[[title]]
      groups     <- comparison[["groups"]]
      group_col  <- paste(groups, collapse = "_")

      table <- table %>%
        gt::tab_spanner(
          id     = paste0("spanner_", group_col),
          label  = title,
          columns = gt::ends_with(group_col)
        ) %>%
        gt::cols_merge(
          columns = c(paste0("f_wald:", group_col), paste0("annotation:", group_col)),
          pattern = "{1}<<{2}>>"
        )
    }

    # Footnotes based on annotations
    annotations <- df_wald %>%
      dplyr::select(dplyr::starts_with("annotation"))

    footnotes_needed <- annotations %>%
      unlist(use.names = FALSE) %>%
      unique() %>%
      setdiff(NA)


    footnotes_needed <- unique(footnotes_needed)
    footnotes <- c()
    if ("*" %in% footnotes_needed) {
      footnotes <- c(footnotes, "&ast; *p* < 0.05")
    }
    if ("**" %in% footnotes_needed) {
      footnotes <- c(footnotes, "&ast;&ast; *p* < 0.01")
    }
    if ("***" %in% footnotes_needed) {
      footnotes <- c(footnotes, "&ast;&ast;&ast; *p* < 0.001")
    }

    table <- table %>%
      gt::tab_options(
        data_row.padding = gt::px(2)
      ) %>%
      gt::cols_width(
        name ~ gt::px(400),
        dplyr::everything() ~ gt::px(100)
      ) %>%
      gt::sub_missing(
        columns = everything(),
        missing_text = ""
      ) %>%
      gt::tab_footnote(
        footnote = gt::md(paste(footnotes, collapse = "; "))
      )

    if ("alternative" %in% colnames(df_wald)) {
      table <- table %>%
        gt::cols_hide(columns = "alternative") %>%
        gt::cols_width(
          alternative ~ gt::px(150)
        ) %>%
        gt::tab_footnote(
          footnote = gt::md("**Continue**: Continue life-sustaining therapy vs. Withdrawal"),
          locations = gt::cells_body(
            columns = "name",
            rows    = type == "Constant" & alternative == "Continue"
          )
        ) %>%
        gt::tab_footnote(
          footnote = gt::md("**Time-Limited**: Time-Limited Trial vs. Withdrawal"),
          locations = gt::cells_body(
            columns = "name",
            rows    = type == "Constant" & alternative == "Time-Limited"
          )
        )
    }

    table %>%
      gt::gtsave(
        filename = fs::path(datadir, "tables", modeltype, "table_pooled_group_comparison.html")
      )

    tables[[modeltype]] <- table
  }

  return(tables)
}

