# Plots group comparison of coefficient weights

Creates plots with coefficients weights and significance levels
comparing both groups using the Wald test. Saves the plots as png and
svg in the `data\figures` folder.

## Usage

``` r
plot_group_comparison()
```

## Value

ggplot object (of last group)

## Examples

``` r
plot_group_comparison()
#> Comparing: Amsterdam UMC vs. OLVG
#> Comparing: Intensivists vs. Fellows
```
