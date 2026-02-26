#' Plot Relative Importance
#'
#' Creates plots showing the relative factor importance using Maximum Utility Contribution for the aggregate
#' model for both the binary and multinomial models of all participants and subgroups.
#' Saves the plot as png and svg in the `extdata\figures` folder.
#' @return
#' list of ggplots
#' @export
#'
#' @examples
#' baitlist::plot_relative_importance()
plot_relative_importance <- function() {

  groups <- c(
    'aggregate' = "All Participants",
    'aumc' = "Amsterdam UMC",
    'olvg' = "OLVG",
    'intensivists' = "Intensivists",
    'fellows' = "Fellows"
  )

  modeltypes <- c("binary", "multinomial")

  cat("Creating relative importance plots...\n")

  # from R package ggthemes "Classic Cyclic"
  colors = c(
    "#1F83B4FF",
    "#12A2A8FF",
    "#2CA030FF",
    "#78A641FF",
    "#BCBD22FF",
    "#FFBF50FF",
    "#FFAA0EFF",
    "#FF7F0EFF",
    "#D63A3AFF",
    "#C7519CFF",
    "#BA43B4FF",
    "#8A60B0FF",
    "#6F63BBFF"
  )

  plots <- list()

  # data directory
  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  for(modeltype in modeltypes) {

    for(group in names(groups)) {

      cat(paste0("Processing ", groups[group], " model (", modeltype, ")...\n"))

      muc <- utils::read.csv(
        fs::path(datadir, "feature_importance", "maximum_utility_contribution", modeltype, paste0(group, ".csv"))
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

      muc <- muc %>%
        dplyr::left_join(
          criteria,
          by = dplyr::join_by(variable)
        )

      if(modeltype == 'binary') {

        plt <- ggplot2::ggplot(
          data = muc,
          mapping = ggplot2::aes(
            x = factor(name, levels=rev(name)),
            y = importance_pct,
            fill = factor(name, levels=name)
          )
        ) +

          # stat = "identity" prevents sorting the variable names
          ggplot2::geom_bar(stat = "identity") +
          ggplot2::scale_fill_manual(values = rev(colors)) +
          ggplot2::labs(
            title = paste0("Factor Importance - ", groups[group]),
            x = NULL,
            y = "Relative importance (%)"
          ) +

          # add percentage labels next to bars
          ggplot2::geom_text(
            ggplot2::aes(
              label = round(importance_pct,1)),
            size = 10/ggplot2::.pt,
            hjust = -0.2) +
          ggplot2::theme_bw() +
          ggplot2::theme(
            axis.text = ggplot2::element_text(size=10),
            legend.position = "none", # hide legend,
            panel.grid.major.x = ggplot2::element_line(
              color = 'lightgrey',
              linewidth = 0.25,
              linetype = 2
            ),
            panel.grid.minor.x = ggplot2::element_blank(), # hide minor vertical grid lines
            panel.grid.major.y = ggplot2::element_blank(), # hide horizontal grid lines
            plot.title = ggplot2::element_text(hjust = 0.5) # centered horizontally
          ) +
          ggplot2::scale_y_continuous(
            expand = ggplot2::expansion(mult = c(0, .1)),
            breaks = seq(0, 30, by = 5)
          ) +
          ggplot2::coord_flip() # flip x and y to allow for horizontal bar chart"
      }
      else if(modeltype == 'multinomial') {

        # change the labels
        muc$alternative <- dplyr::recode(
          muc$alternative,
          "continue" = "Continue vs. Withdraw",
          "timelimited" = "Time-Limited Trial vs. Withdraw"
        )

        # explicit label (value of importance) position
        offset <- max(muc$importance_pct) * 0.0125
        muc$label_pos <- muc$importance_pct + offset

        plt <- ggplot2::ggplot(
          data = muc,
          mapping = ggplot2::aes(
            x = factor(name, levels = rev(unique(name))),
            y = importance_pct,
            fill = factor(name, levels = unique(name)),
            pattern = alternative
          )
        ) +

          ggpattern::geom_col_pattern(
            position = ggplot2::position_dodge2(
              width = 0.8,
              preserve = "single",
              reverse = TRUE
            ),
            width = 0.8,

            # pattern aesthetics
            pattern_fill = "white",
            pattern_colour = "white",     # match background
            pattern_density = 0.5,
            pattern_spacing = 0.01,
            pattern_angle = 45,
            pattern_size = 0.15           # thinner = no bleed
          ) +

          # remove fill legend
          ggplot2::scale_fill_manual(values = rev(colors), guide = "none") +

          ggpattern::scale_pattern_manual(values = c("none", "stripe")) +

          ggplot2::labs(
            title = paste0("Factor Importance - ", groups[group]),
            x = NULL,
            y = "Relative importance (%)",
            pattern = "Alternative"
          ) +

          ggplot2::geom_text(
            ggplot2::aes(
              x = factor(name, levels = rev(unique(name))),
              y = label_pos,
              label = round(importance_pct, 1)),
            position = ggplot2::position_dodge2(
              width = 0.8,
              preserve = "single",
              reverse = TRUE
            ),
            hjust = 0,
            size = 10/ggplot2::.pt
          ) +

          ggplot2::theme_bw() +
          ggplot2::theme(
            axis.text = ggplot2::element_text(size = 10),
            legend.position = "top",
            legend.direction = "horizontal",
            panel.grid.major.x = ggplot2::element_line(
              color = 'lightgrey',
              linewidth = 0.25,
              linetype = 2
            ),
            panel.grid.minor.x = ggplot2::element_blank(),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.title = ggplot2::element_text(hjust = 0.5)
          ) +

          ggplot2::scale_y_continuous(
            expand = ggplot2::expansion(mult = c(0, .1)),
            breaks = seq(0, 30, by = 5)
          ) +

          ggplot2::coord_flip()
      }

      file_types <- c('png', 'svg')

      for(file_type in file_types) {
        ggplot2::ggsave(
          fs::path(datadir, "figures", modeltype, paste0("factor_importance_", group, ".", file_type)),
          plot = plt,
          width = 9,
          height = 7,
          dpi = 300,
          create.dir = TRUE)
      }

      plots[[modeltype]][[group]] <- plt

    }

  }

  return(plots)
}

#' Plots group comparison of coefficient weights
#'
#' Creates plots with coefficients weights and significance levels comparing both groups using the Wald test.
#' Saves the plots as png and svg in the `extdata\figures` folder.
#' @return
#' list of ggplots
#' @export
#'
#' @examples
#' baitlist::plot_group_comparison()
plot_group_comparison <- function() {
  comparisons <- list(
    'Amsterdam UMC vs. OLVG'=list(
      groups = c('aumc','olvg'),
      colors = c('#F07814', '#17428C')
    ),
    'Intensivists vs. Fellows'=list(
      groups = c('intensivists','fellows'),
      colors = c('#006BA4', '#A2C8EC') # From Tableau Colorblind
    )
  )

  modeltypes <- c('binary', 'multinomial')

  plots <- list()

  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  for(modeltype in modeltypes) {

    plots[[modeltype]] <- list()

    for(title in names(comparisons)) {
      cat(paste0("Comparing: ", title, "\n" ))
      comparison <- comparisons[[title]]
      groups <- comparison[['groups']]
      group1 <- groups[[1]]
      group2 <- groups[[2]]

      colors <- comparison[['colors']]

      group1_name <- strsplit(title, split=" vs. ")[[1]][[1]]
      group2_name <- strsplit(title, split=" vs. ")[[1]][[2]]

      wald <- utils::read.csv(
        fs::path(datadir, "wald", modeltype, paste0(paste(groups, collapse="-"), ".csv"))
      )

      feature_importance_measure <- "standardized_coefficients"
      fi_col <- 'std_coef'

      fi1 <- utils::read.csv(
        fs::path(datadir, "feature_importance", feature_importance_measure, modeltype, paste0(group1, ".csv"))
      ) %>%
        dplyr::select(coefficient_name, variable, all_of(!!fi_col)) %>%
        dplyr::rename(!!paste0(fi_col, "_", group1) := fi_col)

      fi2 <- utils::read.csv(
        fs::path(datadir, "feature_importance", feature_importance_measure, modeltype, paste0(group2, ".csv"))
      ) %>%
        dplyr::select(coefficient_name, variable, all_of(!!fi_col)) %>%
        dplyr::rename(!!paste0(fi_col, "_", group2) := fi_col)

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

      # join Wald data frame with relative importance (for presentation in graph)
      wald <- wald %>%
        dplyr::left_join(
          fi1,
          by = dplyr::join_by(coefficient_name)
        ) %>%
        dplyr::left_join(
          fi2,
          by = dplyr::join_by(coefficient_name)
        )

      # pivot columns to rows
      wald <- wald %>%
        tidyr::pivot_longer(
          cols = matches(paste0("coef_|se_coef_|", fi_col, "_")),
          names_to = c(".value", "group"),
          names_pattern = c(paste0("(coef|se_coef|", fi_col, ")_(.*)"))
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

      # join with criteria and only keep valid variables (e.g. remove constants)
      wald <- wald %>%
        dplyr::right_join(
          criteria,
          by = dplyr::join_by(variable)
        )

      # rename group names to 'friendly' names
      wald <- wald %>%
        dplyr::mutate(
          dplyr::across('group', \(x) stringr::str_replace(x, group1, group1_name)),
          dplyr::across('group', \(x) stringr::str_replace(x, group2, group2_name))
        )

      # change the labels
      wald$alternative <- dplyr::recode(
        wald$alternative,
        "continue" = "Continue vs. Withdraw",
        "timelimited" = "Time-Limited Trial vs. Withdraw"
      )

      if(modeltype == 'binary') {
        # plot group1 vs group2
        plt <- ggplot2::ggplot(
          data = wald,
          mapping = ggplot2::aes(
            x = factor(name, levels = rev(unique(name))),
            y = .data[[fi_col]],
            fill = factor(group, levels = rev(unique(group)))
          )
        ) +
          # stat = "identity" prevents sorting the variable names
          ggplot2::geom_bar(
            position = "dodge",
            stat = "identity"
          ) +
          ggplot2::scale_fill_manual(values = rev(colors)) +
          ggplot2::labs(
            title = paste0("Factor Importance: ", title),
            x = NULL,
            y = "Coefficient Weight",
            fill = "Group"
          ) +
          ggplot2::guides(
            fill = ggplot2::guide_legend(reverse = TRUE)) +
          ggplot2::theme_bw() +
          ggplot2::theme(
            axis.text = ggplot2::element_text(size = 10),
            panel.grid.major.x = ggplot2::element_line(
              color = 'lightgrey',
              linewidth = 0.25,
              linetype = 2
            ),
            panel.grid.minor.x = ggplot2::element_blank(), # hide vertical minor grid lines
            panel.grid.major.y = ggplot2::element_blank(), # hide horizontal grid lines
            plot.title = ggplot2::element_text(hjust = 0.5) # centered horizontally
          ) +
          ggplot2::coord_flip() # flip x and y to allow for horizontal bar chart"
      }
      else if (modeltype == 'multinomial') {

        plt <- ggplot2::ggplot(
          data = wald,
          mapping = ggplot2::aes(
            x = factor(name, levels = rev(unique(name))),
            y = .data[[fi_col]],
            fill = factor(group, levels = rev(unique(group)))
          )
        ) +
          ggplot2::geom_bar(
            position = "dodge",
            stat = "identity"
          ) +
          ggplot2::scale_fill_manual(values = rev(colors)) +
          ggplot2::labs(
            title = paste0("Factor Importance: ", title),
            x = NULL,
            y = "Coefficient Weight",
            fill = "Group"
          ) +
          ggplot2::guides(
            fill = ggplot2::guide_legend(reverse = TRUE)
          ) +
          ggplot2::theme_bw() +
          ggplot2::theme(
            axis.text = ggplot2::element_text(size = 10),
            panel.grid.major.x = ggplot2::element_line(
              color = 'lightgrey',
              linewidth = 0.25,
              linetype = 2
            ),
            panel.grid.minor.x = ggplot2::element_blank(),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.title = ggplot2::element_text(hjust = 0.5)
          ) +
          ggplot2::facet_wrap(~ alternative, ncol = 1) +
          ggplot2::coord_flip()

      }


      # create data frame containing significant differences based on Wald
      half_width <- 0.5/2
      y_offset <- 0.10


      if (modeltype == "binary") {

        df_signif <- wald %>%
          dplyr::select(
            coefficient_name,
            name,
            group,
            all_of(!!fi_col),
            wald,
            p_value) %>%
          tidyr::pivot_wider(
            names_from = group,
            values_from = !!fi_col
          ) %>%
          dplyr::mutate(xmid = dplyr::n() + 1 - dplyr::row_number()) %>%
          dplyr::mutate(
            xmin = xmid - half_width,
            xmax = xmid + half_width,
            y_position = max(.data[[group1_name]], .data[[group2_name]]) * (1 + y_offset),
            height = (max(.data[[group1_name]], .data[[group2_name]]) -
                        min(.data[[group1_name]], .data[[group2_name]])),
            annotation = dplyr::case_when(
              p_value < 0.001 ~ '***',
              p_value < 0.01 ~ '**',
              p_value < 0.05 ~ '*',
              .default = "NS"
            )
          ) %>%
          dplyr::mutate(
            tip_length_1 = dplyr::case_when(
              .data[[group1_name]] < 0 ~
                (y_position/(1 + y_offset/2) / height),
              .default =
                ((y_position/(1 + y_offset/2) - .data[[group1_name]]) / height)
            ),
            tip_length_2 = dplyr::case_when(
              .data[[group2_name]] < 0 ~
                (y_position/(1 + y_offset/2) / height),
              .default =
                ((y_position/(1 + y_offset/2) - .data[[group2_name]]) / height)
            )
          ) %>%
          dplyr::filter(!is.na(annotation))

      } else if (modeltype == "multinomial") {

        df_signif <- wald %>%
          dplyr::select(
            coefficient_name,
            name,
            group,
            alternative,
            all_of(!!fi_col),
            wald,
            p_value
          ) %>%
          tidyr::pivot_wider(
            names_from = group,
            values_from = !!fi_col
          ) %>%
          # xmid logic identical to binary, but done per facet
          dplyr::group_by(alternative) %>%
          dplyr::mutate(
            xmid = dplyr::n() + 1 - dplyr::row_number()
          ) %>%
          dplyr::ungroup() %>%
          dplyr::mutate(
            xmin = xmid - half_width,
            xmax = xmid + half_width,

            y_position = base::max(
              base::max(.data[[group1_name]], na.rm = TRUE),
              base::max(.data[[group2_name]], na.rm = TRUE)
            ) * (1 + y_offset),

            height = base::max(.data[[group1_name]], .data[[group2_name]]) -
              base::min(.data[[group1_name]], .data[[group2_name]]),

            annotation = dplyr::case_when(
              p_value < 0.001 ~ '***',
              p_value < 0.01 ~ '**',
              p_value < 0.05 ~ '*',
              .default = "NS"
            )
          ) %>%
          dplyr::mutate(
            tip_length_1 = dplyr::case_when(
              .data[[group1_name]] < 0 ~
                (y_position / (1 + y_offset/2) / height),
              .default =
                ((y_position / (1 + y_offset/2) - .data[[group1_name]]) / height)
            ),
            tip_length_2 = dplyr::case_when(
              .data[[group2_name]] < 0 ~
                (y_position / (1 + y_offset/2) / height),
              .default =
                ((y_position / (1 + y_offset/2) - .data[[group2_name]]) / height)
            )
          ) %>%
          dplyr::filter(!base::is.na(annotation))

      }

      for (i in seq_len(nrow(df_signif))) {

        row <- df_signif[i, ]

        if (row$annotation == "NS") {
          textsize <- 3
          vjust <- 0.5
          color <- "grey"
        } else {
          textsize <- 5
          vjust <- 0.75
          color <- "black"
        }

        suppressWarnings({
          plt <- plt +
            ggsignif::geom_signif(
              data = row,
              mapping = ggplot2::aes(
                xmin        = xmin,
                xmax        = xmax,
                y_position  = y_position,
                annotations = annotation
              ),
              manual = TRUE,
              inherit.aes = FALSE,
              tip_length = c(row$tip_length_2, row$tip_length_1),
              textsize   = textsize,
              vjust      = vjust,
              color      = color,
              angle      = 360,
              hjust      = 0
            )
        })
      }


      # increase y_margin for horizontally printed annotations of significance brackets and
      # remove last grid line to prevent interfering with the significance brackets
      y_limits <- ggplot2::layer_scales(plt)$y$get_limits()
      y_breaks <- ggplot2::layer_scales(plt)$y$get_breaks()

      # change major grid lines depending on number of grid lines currently > 0
      if(y_breaks[length(y_breaks)] <= 1) {
        by <- 0.5
      }
      else
        by <- 1

      plt <- plt + ggplot2::scale_y_continuous(
        limits = c(y_limits[1], y_limits[2]*1.05),
        breaks = seq(from = y_breaks[1], to = y_breaks[length(y_breaks)] - by, by = by),
        minor_breaks = NULL
      )

      plots[[modeltype]][[paste(groups, collapse="_")]] <- plt

      file_types <- c('png', 'svg')

      for(file_type in file_types) {
        ggplot2::ggsave(
          fs::path(datadir, "figures", modeltype, paste0("group_comparison_", paste(groups, collapse="_"), ".", file_type)),
          plot = plt,
          width = 9,
          height = 5,
          dpi = 300,
          create.dir = TRUE)
      }

    }
  }
  return(plots)
}

#' Plots group comparison of coefficient weights
#'
#' Creates plots with coefficients weights and significance levels comparing both groups using the Wald test.
#' Saves the plots as png and svg in the `data\figures` folder.
#' @return
#' list of ggplots
#' @export
#'
#' @examples
#' baitlist::plot_pooled_group_comparison()
plot_pooled_group_comparison <- function() {
  comparisons <- list(
    'Amsterdam UMC vs. OLVG'=list(
      groups = c('aumc','olvg'),
      colors = c('#F07814', '#17428C')
    ),
    'Intensivists vs. Fellows'=list(
      groups = c('intensivists','fellows'),
      colors = c('#006BA4', '#A2C8EC') # From Tableau Colorblind
    )
  )

  modeltypes <- c('binary', 'multinomial')

  plots <- list()

  datadir <- fs::path_package(
    "extdata", package = "baitlist")

  for(modeltype in modeltypes) {

    plots[[modeltype]] <- list()

    for(title in names(comparisons)) {
      cat(paste0("Comparing: ", title, " (", modeltype, ")\n" ))
      comparison <- comparisons[[title]]
      groups <- comparison[['groups']]
      group1 <- groups[[1]]
      group2 <- groups[[2]]

      colors <- comparison[['colors']]

      group1_name <- strsplit(title, split=" vs. ")[[1]][[1]]
      group2_name <- strsplit(title, split=" vs. ")[[1]][[2]]

      wald_wide <- wald_interaction(group1, group2, modeltype)

      #pivot longer
      wald <- wald_wide %>%
        tidyr::pivot_longer(
          cols = c(coef_group1, coef_group2, se_group1, se_group2),
          names_to = c(".value", "group"),
          names_pattern = "(coef|se)_group(1|2)"
        ) %>%
        dplyr::mutate(
          group = dplyr::recode(group,
                                "1" = group1_name,
                                "2" = group2_name)
        )

      # remove joint test
      wald <- wald %>%
        dplyr::filter((type == "Criteria"))

      # use the coef column  to plot main data "factor importance"
      fi_col <- 'coef'

      dodge <- ggplot2::position_dodge(width = 0.9)

      if(modeltype == 'binary') {
        # plot group1 vs group2
        plt <- ggplot2::ggplot(
          data = wald,
          mapping = ggplot2::aes(
            x = factor(name, levels = rev(unique(name))),
            y = .data[[fi_col]],
            fill = factor(group, levels = rev(unique(group)))
          )
        ) +
          # stat = "identity" prevents sorting the variable names
          ggplot2::geom_bar(
            position = dodge,
            stat = "identity"
          ) +
          ggplot2::geom_errorbar(
            ggplot2::aes(
              ymin = .data[[fi_col]] - 1.96 * se,
              ymax = .data[[fi_col]] + 1.96 * se ),
            width = 0.5,
            position = dodge
            ) +
          ggplot2::scale_fill_manual(values = rev(colors)) +
          ggplot2::labs(
            title = paste0("Factor Importance: ", title),
            x = NULL,
            y = "Coefficient Weight",
            fill = "Group"
          ) +
          ggplot2::guides(
            fill = ggplot2::guide_legend(reverse = TRUE)) +
          ggplot2::theme_bw() +
          ggplot2::theme(
            axis.text = ggplot2::element_text(size = 10),
            panel.grid.major.x = ggplot2::element_line(
              color = 'lightgrey',
              linewidth = 0.25,
              linetype = 2
            ),
            panel.grid.minor.x = ggplot2::element_blank(), # hide vertical minor grid lines
            panel.grid.major.y = ggplot2::element_blank(), # hide horizontal grid lines
            plot.title = ggplot2::element_text(hjust = 0.5) # centered horizontally
          ) +
          ggplot2::coord_flip() # flip x and y to allow for horizontal bar chart"
      }
      else if (modeltype == 'multinomial') {

        # change the labels
        wald$alternative <- dplyr::recode(
          wald$alternative,
          "continue" = "Continue vs. Withdraw",
          "timelimited" = "Time-Limited Trial vs. Withdraw"
        )

        plt <- ggplot2::ggplot(
          data = wald,
          mapping = ggplot2::aes(
            x = factor(name, levels = rev(unique(name))),
            y = .data[[fi_col]],
            fill = factor(group, levels = rev(unique(group)))
          )
        ) +
          ggplot2::geom_bar(
            position = dodge,
            stat = "identity"
          ) +
          ggplot2::geom_errorbar(
            ggplot2::aes(
              ymin = .data[[fi_col]] - 1.96 * se,
              ymax = .data[[fi_col]] + 1.96 * se ),
            width = 0.5,
            position = dodge
          ) +
          ggplot2::scale_fill_manual(values = rev(colors)) +
          ggplot2::labs(
            title = paste0("Factor Importance: ", title),
            x = NULL,
            y = "Coefficient Weight",
            fill = "Group"
          ) +
          ggplot2::guides(
            fill = ggplot2::guide_legend(reverse = TRUE)
          ) +
          ggplot2::theme_bw() +
          ggplot2::theme(
            axis.text = ggplot2::element_text(size = 10),
            panel.grid.major.x = ggplot2::element_line(
              color = 'lightgrey',
              linewidth = 0.25,
              linetype = 2
            ),
            panel.grid.minor.x = ggplot2::element_blank(),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.title = ggplot2::element_text(hjust = 0.5)
          ) +
          ggplot2::facet_wrap(~ alternative, ncol = 1) +
          ggplot2::coord_flip()
      }

      # create data frame containing significant differences based on Wald
      half_width <- 0.5/2
      y_offset <- 0.10


      if (modeltype == "binary") {

        df_signif <- wald %>%
          dplyr::select(
            coefficient_name,
            name,
            group,
            all_of(!!fi_col),
            se,
            wald,
            p_value) %>%
          tidyr::pivot_wider(
            names_from = group,
            values_from = c(!!fi_col, se)
          ) %>%
          dplyr::mutate(
            xmid = dplyr::n() + 1 - dplyr::row_number(),
            xmin = xmid - half_width,
            xmax = xmid + half_width,
            y_position = max(
              .data[[paste0(fi_col, "_", group1_name)]] + 1.96 * .data[[paste0("se_", group1_name)]],
              .data[[paste0(fi_col, "_", group2_name)]] + 1.96 * .data[[paste0("se_", group2_name)]]
              ) * (1 + y_offset),
            annotation = dplyr::case_when(
              p_value < 0.001 ~ '***',
              p_value < 0.01 ~ '**',
              p_value < 0.05 ~ '*',
              .default = "NS"
            )
          ) %>%
          dplyr::mutate(
            tip_length_1 = 0,
            tip_length_2 = 0
          ) %>%
          dplyr::filter(!is.na(annotation))

      } else if (modeltype == "multinomial") {

        df_signif <- wald %>%
          dplyr::select(
            coefficient_name,
            name,
            group,
            alternative,
            all_of(!!fi_col),
            se,
            wald,
            p_value
          ) %>%
          tidyr::pivot_wider(
            names_from = group,
            values_from = c(!!fi_col, se)
          ) %>%
          # xmid logic identical to binary, but done per facet
          dplyr::group_by(alternative) %>%
          dplyr::mutate(
            xmid = dplyr::n() + 1 - dplyr::row_number()
          ) %>%
          dplyr::ungroup() %>%
          dplyr::mutate(
            xmin = xmid - half_width,
            xmax = xmid + half_width,
            y_position = max(
              .data[[paste0(fi_col, "_", group1_name)]] + 1.96 * .data[[paste0("se_", group1_name)]],
              .data[[paste0(fi_col, "_", group2_name)]] + 1.96 * .data[[paste0("se_", group2_name)]]
            ) * (1 + y_offset),
            annotation = dplyr::case_when(
              p_value < 0.001 ~ '***',
              p_value < 0.01 ~ '**',
              p_value < 0.05 ~ '*',
              .default = "NS"
            )
          ) %>%
          dplyr::mutate(
            tip_length_1 = 0,
            tip_length_2 = 0
          ) %>%
          dplyr::filter(!base::is.na(annotation))

      }

      for (i in seq_len(nrow(df_signif))) {

        row <- df_signif[i, ]

        if (row$annotation == "NS") {
          textsize <- 3
          vjust <- 0.5
          color <- "grey"
        } else {
          textsize <- 5
          vjust <- 0.75
          color <- "black"
        }

        suppressWarnings({
          plt <- plt +
            ggsignif::geom_signif(
              data = row,
              mapping = ggplot2::aes(
                xmin        = xmin,
                xmax        = xmax,
                y_position  = y_position,
                annotations = annotation
              ),
              manual = TRUE,
              inherit.aes = FALSE,
              tip_length = c(row$tip_length_2, row$tip_length_1),
              textsize   = textsize,
              vjust      = vjust,
              color      = color,
              angle      = 360,
              hjust      = 0
            )
        })
      }


      # increase y_margin for horizontally printed annotations of significance brackets and
      # remove last grid line to prevent interfering with the significance brackets
      y_limits <- ggplot2::layer_scales(plt)$y$get_limits()
      y_breaks <- ggplot2::layer_scales(plt)$y$get_breaks()

      # change major grid lines depending on number of grid lines currently > 0
      if(y_breaks[length(y_breaks)] <= 1) {
        by <- 0.5
      }
      else
        by <- 1

      plt <- plt + ggplot2::scale_y_continuous(
        limits = c(y_limits[1], y_limits[2]*1.05),
        breaks = seq(from = y_breaks[1], to = y_breaks[length(y_breaks)] - by, by = by),
        minor_breaks = NULL
      )

      plots[[modeltype]][[paste(groups, collapse="_")]] <- plt

      file_types <- c('png', 'svg')

      for(file_type in file_types) {
        ggplot2::ggsave(
          fs::path(datadir, "figures", modeltype, paste0("pooled_group_comparison_", paste(groups, collapse="_"), ".", file_type)),
          plot = plt,
          width = 9,
          height = 9,
          dpi = 300,
          create.dir = TRUE)
      }
    }

  }
  return(plots)
}
