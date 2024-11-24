#' Plot Relative Importance
#'
#' Creates a plot showing the relative factor importance using Maximum Utility Contribution for the aggregate
#' model. Saves the plot as png and svg in the `data\figures` folder.
#' @return
#' ggplot object
#' @export
#'
#' @examples
#' plot_relative_importance()
plot_relative_importance <- function() {

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


  group <- 'aggregate'
  muc <- read.csv(paste0(
    './data/feature_importance/maximum_utility_contribution/binary/', group, '.csv')
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

  muc <- muc %>%
    dplyr::left_join(
      criteria,
      by = dplyr::join_by(variable)
      )


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
      title = "Factor Importance",
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

  file_types <- c('png', 'svg')

  for(file_type in file_types) {
    ggplot2::ggsave(
      paste0("./data/figures/factor_importance_", group, ".", file_type),
      plot = plt,
      width = 9,
      height = 7,
      dpi = 300,
      create.dir = TRUE)
  }

  return(plt)
}

#' Converts apollo coefficient_name (b_) to variable name.
#'
#' @param coef_name
#'
#' @return
#' variable name
#' @export
#'
#' @examples
#' variable <- coefficient_to_variable("b_age")
coefficient_to_variable <- function(coef_name) {
  name_split <- strsplit(coef_name, split="b_")[[1]]
  if(length(name_split) > 1) {
    variable_name <- name_split[[2]]

    return(variable_name)
  }
  else {
    return(NA)
  }
}

#' Plots group comparison of coefficient weights
#'
#' Creates plots with coefficients weights and significance levels comparing both groups using the Wald test.
#' Saves the plots as png and svg in the `data\figures` folder.
#' @return
#' ggplot object (of last group)
#' @export
#'
#' @examples
#' plot_group_comparison()
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

  # create a vectorized version of function to allow using in dplyr functions
  coefficient_to_variable_V <- Vectorize(coefficient_to_variable)

  for(title in names(comparisons)) {
    cat(paste0("Comparing: ", title, "\n" ))
    comparison <- comparisons[[title]]
    groups <- comparison[['groups']]
    group1 <- groups[[1]]
    group2 <- groups[[2]]

    colors <- comparison[['colors']]

    group1_name <- strsplit(title, split=" vs. ")[[1]][[1]]
    group2_name <- strsplit(title, split=" vs. ")[[1]][[2]]

    wald <- read.csv(paste0(
      "./data/wald/", paste(groups, collapse="-"), ".csv")
    )

    feature_importance_measure <- "standardized_coefficients"
    fi_col <- 'std_coef'

    fi1 <- read.csv(paste0(
      "./data/feature_importance/", feature_importance_measure, "/binary/", group1, ".csv")
    ) %>%
      dplyr::select(variable, all_of(!!fi_col)) %>%
      dplyr::rename(!!paste0(fi_col, "_", group1) := fi_col)

    fi2 <- read.csv(paste0(
      "./data/feature_importance/", feature_importance_measure, "/binary/", group2, ".csv")
    ) %>%
      dplyr::select(variable, all_of(!!fi_col)) %>%
      dplyr::rename(!!paste0(fi_col, "_", group2) := fi_col)

    # determine variable name (e.g. strip "b_" from name)
    wald <- wald %>%
      dplyr::mutate(variable = coefficient_to_variable_V(coefficient_name)) %>%
      dplyr::mutate_at("variable", as.character)

    # join Wald data frame with relative importance (for presentation in graph)
    wald <- wald %>%
      dplyr::left_join(
        fi1,
        by = dplyr::join_by(variable)
      ) %>%
      dplyr::left_join(
        fi2,
        by = dplyr::join_by(variable)
      )

    # pivot columns to rows
    wald <- wald %>%
      tidyr::pivot_longer(
        cols = matches(paste0("coef_|se_coef_|", fi_col, "_")),
        names_to = c(".value", "group"),
        names_pattern = c(paste0("(coef|se_coef|", fi_col, ")_(.*)"))
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


    # create data frame containing significant differences based on Wald
    half_width <- 0.5/2
    y_offset <- 0.10

    df_signif <- wald %>%
      dplyr::select(coefficient_name, group, all_of(!!fi_col), wald, p_value) %>%
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

    for(row in 1:nrow(df_signif)) {
      annotation <- df_signif[[row, 'annotation']]
      if(annotation == 'NS') {
        textsize <- 3
        vjust <- 0.5
        color <- 'grey'
      }
      else {
        # allow '*' to be slighlty larger compared to "NS"
        # and align correctly
        textsize <- 5
        vjust <- 0.75
        color <- "black"
      }

      plt <- plt +
        ggsignif::geom_signif(
          annotation = annotation,
          y_position = df_signif[[row, 'y_position']],
          xmin = df_signif[[row, 'xmin']],
          xmax = df_signif[[row, 'xmax']],
          tip_length = c(
            df_signif[[row, 'tip_length_2']],
            df_signif[[row, 'tip_length_1']]
            ),
          hjust = 0,
          vjust = vjust,
          angle = 360,
          textsize = textsize,
          color = color
        )
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

    file_types <- c('png', 'svg')

    for(file_type in file_types) {
      ggplot2::ggsave(
        paste0("./data/figures/group_comparison_", paste(groups, collapse="_"), ".", file_type),
        plot = plt,
        width = 9,
        height = 5,
        dpi = 300,
        create.dir = TRUE)
    }

  }

  return(plt)

}


