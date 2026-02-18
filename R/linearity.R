#' Runs linearity tests for multi-level ordered categories.
#'
#' @returns object containing gt table and combined plot
#' @export
#'
#' @examples
#' run_linearity_tests()
run_linearity_tests <- function() {

  # ------------------------------------------------------------
  # Prespecified valid levels for each ordered variable
  # ------------------------------------------------------------
  valid_levels <- list(
    age                       = 0:3,
    frailty                   = 0:2,
    life_expectancy           = 0:2,
    disability_cardiovascular = 0:3,
    disability_pulmonary      = 0:2,
    disability_renal          = 0:2,
    disability_neurological   = 0:2
  )

  ordered_vars <- names(valid_levels)

  # data directory
  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  db <- load_responses("aggregate")

  # ------------------------------------------------------------
  # Create dummy variables
  # ------------------------------------------------------------
  create_dummies <- function(df, var, levels) {

    df[[var]] <- as.numeric(df[[var]])

    for (lv in levels) {
      dummy_name <- paste0(var, lv)
      df[[dummy_name]] <- as.integer(df[[var]] == lv)
    }

    df
  }

  # apply dummy creation + quadratic terms
  for (var in ordered_vars) {
    lv <- valid_levels[[var]]
    db <- create_dummies(db, var, lv)
    db[[paste0(var, "_sq")]] <- db[[var]]^2
  }

  dummy_names <- function(var) paste0(var, valid_levels[[var]])

  # ------------------------------------------------------------
  # Model fitters
  # ------------------------------------------------------------
  fit_glm_linear <- function(var) {
    glm(reformulate(var, "CHOICE_BINARY"), data = db, family = binomial())
  }

  fit_glm_quad <- function(var) {
    glm(reformulate(c(var, paste0(var, "_sq")), "CHOICE_BINARY"),
        data = db, family = binomial())
  }

  # Dummy model: FORCE dummy0 as baseline by excluding it
  fit_glm_dummy <- function(var) {
    dums <- dummy_names(var)
    dums_no0 <- dums[dums != paste0(var, "0")]   # remove baseline
    glm(reformulate(dums_no0, "CHOICE_BINARY"), data = db, family = binomial())
  }

  # ------------------------------------------------------------
  # Extract dummy effects (always include all prespecified levels)
  # ------------------------------------------------------------
  extract_dummy_effects <- function(model, var) {

    lv <- valid_levels[[var]]
    dums <- paste0(var, lv)
    dums_no0 <- dums[dums != paste0(var, "0")]

    coef_tab <- coef(summary(model))
    coef_names <- rownames(coef_tab)

    dums_in_model <- intersect(dums_no0, coef_names)

    df <- tibble::tibble()

    if (length(dums_in_model) > 0) {
      coefs <- coef_tab[dums_in_model, , drop = FALSE]
      levels_in_model <- as.numeric(gsub(paste0("^", var), "", dums_in_model))

      df <- tibble::tibble(
        variable = var,
        level    = levels_in_model,
        estimate = coefs[, "Estimate"],
        se       = coefs[, "Std. Error"],
        lower    = estimate - 1.96 * se,
        upper    = estimate + 1.96 * se
      )
    }

    # Add baseline (dummy0)
    if (0 %in% lv) {
      df0 <- tibble::tibble(
        variable = var,
        level    = 0,
        estimate = 0,
        se       = 0,
        lower    = 0,
        upper    = 0
      )
      df <- dplyr::bind_rows(df0, df)
    }

    # Add missing levels (if any)
    missing_levels <- setdiff(lv, df$level)
    if (length(missing_levels) > 0) {
      df_missing <- tibble::tibble(
        variable = var,
        level    = missing_levels,
        estimate = 0,
        se       = 0,
        lower    = 0,
        upper    = 0
      )
      df <- dplyr::bind_rows(df, df_missing)
    }

    dplyr::arrange(df, level)
  }

  # ------------------------------------------------------------
  # Plotting
  # ------------------------------------------------------------
  plot_linearity <- function(df_var, criteria) {
    var <- df_var$variable[1]
    lv  <- valid_levels[[var]]

    # level to description lookup
    crit_sub <- dplyr::filter(criteria, variable == var, level %in% lv)
    lab <- crit_sub$description
    names(lab) <- crit_sub$level

    ggplot2::ggplot(df_var, ggplot2::aes(x = level, y = estimate)) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dotted", color = "grey60") +
      ggplot2::geom_point(size = 3, color = "#1f77b4") +
      ggplot2::geom_line(color = "#1f77b4") +
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = lower, ymax = upper),
        alpha = 0.15
      ) +
      ggplot2::geom_smooth(
        method   = "lm",
        se       = FALSE,
        color    = "red",
        linetype = "dashed"
      ) +
      ggplot2::scale_x_continuous(
        breaks = lv,
        labels = stringr::str_wrap(lab, width = 12)
      ) +
      ggplot2::labs(
        title = crit_sub$name[1],
        x     = "Category",
        y     = "Coefficient"
      ) +
      ggplot2::theme_minimal(
        base_size = 12
        ) +
      ggplot2::theme(
        plot.margin = ggplot2::margin(15, 15, 15, 15)
      )
  }


  # ------------------------------------------------------------
  # Main loop
  # ------------------------------------------------------------
  results <- list()
  plots   <- list()


  # add human readable names to data set
  criteria <- readxl::read_excel(
    fs::path(datadir, "model_criteria.xlsx")
  ) %>%
  dplyr::select(ID_Alternative, Name, Level, Description) %>%
  dplyr::distinct() %>%
  dplyr::rename(
    "variable" = "ID_Alternative",
    "name" = "Name",
    "level" = "Level",
    "description" = "Description"
  )

  for (var in ordered_vars) {

    message("Testing linearity for: ", var)

    m_lin   <- fit_glm_linear(var)
    m_quad  <- fit_glm_quad(var)
    m_dummy <- fit_glm_dummy(var)

    # LR test: linear vs dummy
    lr_test <- anova(m_lin, m_dummy, test = "Chisq")
    lr_p <- lr_test$`Pr(>Chi)`[2]

    # quadratic term p-value
    quad_name <- paste0(var, "_sq")
    quad_coef <- summary(m_quad)$coef[quad_name, , drop = TRUE]
    quad_p <- quad_coef["Pr(>|z|)"]

    results[[var]] <- tibble::tibble(
      variable   = var,
      name = criteria$name[criteria$variable == var & criteria$level == 0],
      LR_p       = lr_p,
      quad_p     = quad_p,
      AIC_linear = AIC(m_lin),
      AIC_dummy  = AIC(m_dummy),
      conclusion = dplyr::case_when(
        lr_p > 0.05 & quad_p > 0.05 ~ "Linear",
        lr_p <= 0.05                ~ "Non-linear",
        quad_p <= 0.05              ~ "Curved",
        TRUE                        ~ "Inconclusive"
      )
    )

    df_dummy     <- extract_dummy_effects(m_dummy, var)
    plots[[var]] <- plot_linearity(df_dummy, criteria)

  }

  dashboard <- patchwork::wrap_plots(plots, ncol = 2) +
    patchwork::plot_annotation(
      title    = "Ordered covariates",
      subtitle = "Using level-specific coefficients (baseline: first level)",
      theme    = ggplot2::theme(
        plot.title = ggplot2::element_text(size = 18, face = "bold")
      )
    )

  file_types <- c('png', 'svg')

  for(file_type in file_types) {
    ggplot2::ggsave(
      fs::path(datadir, "linearity", paste0("linearity_plots", ".", file_type)),
      plot     = dashboard,
      width    = 21,
      height   = 29.7,
      units    = "cm",
      dpi      = 300,
      create.dir = TRUE)
  }

  summary = dplyr::bind_rows(results)

  summary_table <- summary %>%
    dplyr::select(-variable) %>%
    dplyr::mutate(
      LR_p       = dplyr::case_when(
        LR_p < 0.001 & LR_p >= 0 ~ "< 0.001",
        .default = sprintf("%.3f", LR_p)
        ),
      quad_p     = dplyr::case_when(
        quad_p < 0.001 & quad_p >= 0 ~ "< 0.001",
        .default = sprintf("%.3f", quad_p)
        ),
      AIC_linear = round(AIC_linear, 1),
      AIC_dummy  = round(AIC_dummy, 1)
    ) %>%
    gt::gt() %>%
    gt::fmt_markdown() %>%
    gt::tab_header(
      title = "Linearity Diagnostics for Ordered Covariates",
    ) %>%
    gt::cols_label(
      name       = "Covariate",
      LR_p       = gt::md("Likelihood-ratio test *(p)*"),
      quad_p     = gt::md("Quadratic term *(p)*"),
      AIC_linear = "AIC: linear model",
      AIC_dummy  = "AIC: categorical model",
      conclusion = "Preferred functional form"
    ) %>%
    gt::tab_style(
      style = gt::cell_text(weight = "bold"),
      locations = gt::cells_column_labels(everything())
    ) %>%
    gt::tab_footnote(
      footnote = "Likelihood-ratio test comparing linear vs. level-specific coeficients model.",
      locations = gt::cells_column_labels(columns = LR_p)
    ) %>%
    gt::tab_footnote(
      footnote = "Wald test for the quadratic (x²) term in a polynomial model.",
      locations = gt::cells_column_labels(columns = quad_p)
    ) %>%
    gt::tab_footnote(
      footnote = "Akaike Information Criterion; lower values indicate better relative model support.",
      locations = gt::cells_column_labels(columns = c(AIC_linear, AIC_dummy))
    ) %>%
    gt::tab_options(
      table.font.size = 14,
      data_row.padding = gt::px(4),
      table.width = gt::pct(100)
      )

  summary_table %>%
    gt::gtsave(
      filename = fs::path(datadir, "linearity", "linearity_diagnostics.html")
    )

  return(list(
    summary_table = summary_table,
    dashboard     = dashboard
  ))
}
