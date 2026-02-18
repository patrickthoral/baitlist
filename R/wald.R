#' Compare feature importance of models using the Wald test
#'
#' Uses the Wald test to pairwise compare features in both models. The Wald test is defined as
#' \eqn{W = \frac {(\beta_{1} - \beta_{2}) ^2}{\operatorname {se}(\beta_{1})^2 + \operatorname {se}(\beta_{2})^2} }

#' Creates csv files in `extdata/wald/<binary|multinomial` containg the model
#' weights and the Wald test and p values.
#' @export
compare_models <- function() {
  comparisons <- list(
    'Amsterdam UMC vs. OLVG'=c('aumc','olvg'),
    'Intensivists vs. Fellows'=c('intensivists','fellows')
  )

  modeltypes <- c(
    'binary', 'multinomial'
  )

  for(modeltype in modeltypes) {

    for(title in names(comparisons)) {
      cat(paste0("Comparing: ", title, "(", modeltype, " model)\n" ))
      groups <- comparisons[[title]]

      group1 = groups[[1]]
      model1 = readRDS(
        fs::path_package(
          "extdata", "apollo", modeltype, paste0("baitlist_", group1, "_model.rds"),
          package = "baitlist")
      )

      group2 = groups[[2]]
      model2 = readRDS(
        fs::path_package(
          "extdata", "apollo", modeltype, paste0("baitlist_", group2, "_model.rds"),
          package = "baitlist")
      )

      coef1 <- model1$estimate
      se1 <- model1$robse

      coef2 <- model2$estimate
      se2 <- model2$robse

      alpha <- 0.05

      coef_names <- character()
      coef1_values <- double()
      se1_values <- double()
      coef2_values <- double()
      se2_values <- double()
      wald_stats <- double()
      p_values <- double()
      notes <- character()

      for(c_name in names(coef1)) {
        c1 = coef1[[c_name]]
        s1 = se1[[c_name]]

        c2 = coef2[[c_name]]
        s2 = se2[[c_name]]

        wald_stat = (c1 - c2)^2/(s1^2 + s2^2)
        p_value <- 1 - pchisq(wald_stat, df = 1)

        note = ""
        if(!is.na(p_value) & p_value < alpha) {
          note <- "*"
        }

        coef_names <- append(coef_names, c_name)
        coef1_values <- append(coef1_values, c1)
        se1_values <- append(se1_values, s1)

        coef2_values <- append(coef2_values, c2)
        se2_values <- append(se2_values, s2)

        wald_stats <- append(wald_stats, wald_stat)
        p_values <- append(p_values, p_value)

        if(note == '*') {
          notes <- append(notes, note)
        }
        else {
          notes <- append(notes, NA)
        }

        cat(
          paste0(
            c_name,
            " (",
            signif(c1, digits=3),
            " vs. ",
            signif(c2, digits=3),
            "), Wald: ", signif(wald_stat, digits=3),
            ", p = ", signif(p_value, digits=3),
            note,
            "\n"
          )
        )
      }

      coef1_value_name = paste0('coef_', comparisons[[title]][1])
      se1_value_name = paste0('se_coef_', comparisons[[title]][1])
      coef2_value_name = paste0('coef_', comparisons[[title]][2])
      se2_value_name = paste0('se_coef_', comparisons[[title]][2])

      tbl_wald <-  dplyr::tibble(coefficient_name=coef_names,
                                 coef1_value=coef1_values,
                                 se1_value=se1_values,
                                 coef2_value=coef2_values,
                                 se2_value=se2_values,
                                 wald = wald_stats,
                                 p_value = p_values,
                                 sign = notes) %>%
        dplyr::rename(!!coef1_value_name :=coef1_value,
                      !!se1_value_name :=se1_value,
                      !!coef2_value_name :=coef2_value,
                      !!se2_value_name :=se2_value
        )

      # print Wald stats
      print(tbl_wald, n = 27)

      # save Wald stats to disk
      write.csv(
        tbl_wald,
        fs::path_package(
          "extdata", "wald", modeltype, paste0(paste(comparisons[[title]], collapse="-"), ".csv"),
          package = "baitlist"),
        row.names = FALSE
      )

      cat(paste0("\n\n" ))
    } # end comparison groups

  } # end model types
}

#' Creates a dataframe containing the Joint Wald test and Wald tests for
#' individual coefficients in a pooled interaction model of two groups
#' @param group1 First group
#' @param group2 Second group
#' @param modeltype Model type: 'binary' or 'multinomial'
#'
#' @returns dataframe
#' @export
#'
#' @examples
#' wald_interaction('intensivist', 'fellows', 'binary')
wald_interaction <- function(group1, group2, modeltype) {

  group_col  <- paste0(group1, "_", group2)

  # Load pooled interaction model
  datadir <- fs::path_package("extdata", package = "baitlist")

  model <- readRDS(
    fs::path(
      datadir, "apollo", "pooled", modeltype,
      paste0("baitlist_pooled_", group1, "_", group2, "_model.rds")
    )
  )

  # Extract robust SEs and covariance matrix
  se_full <- model$robse
  V_full  <- model$robvarcov
  coef_full <- model$estimate

  # Keep only parameters present in BOTH
  common <- intersect(names(se_full), colnames(V_full))
  se <- se_full[common]
  coef <- coef_full[common]
  V <- V_full[common, common, drop = FALSE]

  # Identify main and interaction coefficients
  is_interaction <- grepl("^d_", names(coef))
  is_main <- !is_interaction   # everything else is main

  coef_int <- coef[is_interaction]
  coef_main <- coef[is_main]

  se_int <- se[is_interaction]
  se_main <- se[is_main]

  # Build criterion keys for matching

  # main coefficients:
  criterion_main <- dplyr::case_when(
    grepl("^asc_", names(coef_main)) ~ names(coef_main),
    TRUE ~ names(coef_main) %>%
      stringr::str_replace("^b_", "") |>
      stringr::str_replace("_(continue|timelimited)$", "")
  )

  # interaction coefficients:
  criterion_int <- names(coef_int) %>%
    stringr::str_replace("^d_", "")

  # join by criterion
  df_main <- tibble::tibble(
    coefficient_name = names(coef_main),
    criterion = criterion_main,
    coef_group1 = coef_main,
    se_group1   = se_main,
    group_col = group_col
  )

  df_int <- tibble::tibble(
    criterion = criterion_int,
    coef_int  = coef_int,
    se_int    = se_int
  )

  df_joined <- dplyr::left_join(df_main, df_int, by = "criterion")

  # Compute Group 2 coefficients
  df_joined <- df_joined %>%
    dplyr::mutate(
      coef_group2 = coef_group1 + coef_int
    )

  # Compute SE for Group 2 using covariance matrix
  # Var(beta2) = Var(beta1) + Var(delta) + 2*Cov(beta1, delta)
  df_joined <- df_joined %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      var_group2 =
        V[coefficient_name, coefficient_name] +
        V[paste0("d_", criterion), paste0("d_", criterion)] +
        2 * V[coefficient_name, paste0("d_", criterion)],
      se_group2 = sqrt(var_group2)
    ) %>%
    dplyr::ungroup()

  # Per‑interaction Wald tests
  wald_stat <- (coef_int^2) / (se_int^2)
  p_raw     <- 1 - stats::pchisq(wald_stat, df = 1)
  p_holm    <- p.adjust(p_raw, method = "holm")

  df_wald <- tibble::tibble(
    criterion = criterion_int,
    interaction_name = names(coef_int),
    wald = wald_stat,
    p_raw = p_raw,
    p_value = p_holm
  )

  # Merge Wald results into joined table
  df_final <- dplyr::left_join(df_joined, df_wald, by = "criterion")

  # Joint Wald test
  d_vec <- coef_int
  V_d   <- V[names(coef_int), names(coef_int)]
  W_joint <- as.numeric(t(d_vec) %*% solve(V_d) %*% d_vec)

  df_joint <- tibble::tibble(
    interaction_name = "joint",
    wald = W_joint,
    p_raw = NA_real_,
    p_value = 1 - pchisq(W_joint, df = length(d_vec)),
    group_col = group_col
  )

  wald <- dplyr::bind_rows(df_joint, df_final)

  # Parse coefficient names
  wald <- wald %>%
    tidyr::extract(
      col  = coefficient_name,
      into = c("variable", "variable_alternative", "constant_alternative"),
      regex = "^(?:[bd]_(.*?)(?:_(continue|timelimited))?|(?:d_)?asc_(.*))$",
      remove = FALSE
    ) %>%
    dplyr::mutate(
      dplyr::across(
        c(variable_alternative, constant_alternative),
        ~ dplyr::na_if(.x, "")
      ),
      alternative = dplyr::coalesce(variable_alternative, constant_alternative)
    )

  # Join with criteria names
  criteria <- readxl::read_excel(
    fs::path(datadir, "model_criteria.xlsx")
  ) %>%
    dplyr::select(ID_Alternative, Name) %>%
    dplyr::distinct() %>%
    dplyr::rename(
      "variable" = "ID_Alternative",
      "name"     = "Name"
    )

  wald <- wald %>%
    dplyr::left_join(
      criteria,
      by = dplyr::join_by(variable)
    ) %>%
    dplyr::mutate(
      name = dplyr::case_when(
        stringr::str_detect(interaction_name, "^(d_)?asc_") ~ "Constant",
        stringr::str_detect(interaction_name, "^joint") ~ "Overall Group Difference",
        .default = name
      ),
      type = dplyr::case_when(
        stringr::str_detect(interaction_name, "^(d_)?asc_") ~ "Constant",
        stringr::str_detect(interaction_name, "^joint") ~ "Joint Test",
        .default = "Criteria"
      )
    )

  # Add significance annotation and formatting
  wald <- wald %>%
    dplyr::mutate(
      annotation = dplyr::case_when(
        p_value < 0.001 ~ "***",
        p_value < 0.01  ~ "**",
        p_value < 0.05  ~ "*",
        .default        = NA
      ),
      f_p_value = dplyr::case_when(
        p_value < 0.0001 & p_value >= 0 ~ "< 0.0001",
        .default = formatC(p_value, digits = 3, format = "fg")
      ),
      f_p_raw = dplyr::case_when(
        p_raw < 0.0001 & p_raw >= 0 ~ "< 0.0001",
        is.na(p_raw) ~ "",
        .default = formatC(p_raw, digits = 3, format = "fg")
      ),
      f_wald = formatC(wald, digits = 3, format = "fg"),
      group_col = group_col
    )

  # remove unneeded columns
  if (modeltype != "multinomial")  {
    wald <- wald %>%
      dplyr::select(-alternative)
  }

  wald <- wald %>%
    dplyr::select(-variable_alternative, -constant_alternative, -var_group2)

  return(wald)

}
