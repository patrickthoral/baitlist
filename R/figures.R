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
