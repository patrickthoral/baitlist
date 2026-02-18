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
    # print(tbl_wald)

    # save Wald stats to disk
    write.csv(
      tbl_wald,
      fs::path_package(
        "extdata", "wald", paste0(paste(comparisons[[title]], collapse="-"), ".csv"),
        package = "baitlist"),
      row.names = FALSE
    )

    cat(paste0("\n\n" ))

  }
}
