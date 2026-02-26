# Plots group comparison of coefficient weights

Creates plots with coefficients weights and significance levels
comparing both groups using the Wald test. Saves the plots as png and
svg in the `data\figures` folder.

## Usage

``` r
plot_pooled_group_comparison()
```

## Value

list of ggplots

## Examples

``` r
baitlist::plot_pooled_group_comparison()
#> Comparing: Amsterdam UMC vs. OLVG (binary)
#> Comparing: Intensivists vs. Fellows (binary)
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Comparing: Amsterdam UMC vs. OLVG (multinomial)
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_signif()`).
#> Warning: no non-missing arguments to max; returning -Inf
#> Error in ggsignif::geom_signif(data = row, mapping = ggplot2::aes(xmin = xmin,     xmax = xmax, y_position = y_position, annotations = annotation),     manual = TRUE, inherit.aes = FALSE, tip_length = c(row$tip_length_2,         row$tip_length_1), textsize = textsize, vjust = vjust,     color = color, angle = 360, hjust = 0): Problem while computing stat.
#> ℹ Error occurred in the 3rd layer.
#> Caused by error in `seq_len()`:
#> ! argument must be coercible to non-negative integer
```
