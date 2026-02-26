# Fits a pooled binary model with interaction effects using data from both `group1` and `group2` to allow comparing difference in coefficients between groups

Fits a pooled binary model with interaction effects using data from both
`group1` and `group2` to allow comparing difference in coefficients
between groups

## Usage

``` r
fit_pooled_interaction_binary(group1, group2)
```

## Arguments

- group1:

  First Group

- group2:

  Second group

## Value

Apollo model object

## Examples

``` r
baitlist::fit_pooled_interaction_binary('aumc', 'olvg')
#> 
#> Apollo model summary
#> 
#> Model name                   : baitlist_pooled_aumc_olvg
#> Model description            : Pooled binary logit with group interactions
#> Estimation method            : bgw
#> 
#> LL(final)                    : -452.09
#> Estimated parameters         : 26
#> 
#> Estimates:
#>                  asc_continue                b_expected_los 
#>                      5.832000                     -0.257200 
#>          b_clinical_situation                         b_age 
#>                      0.425200                     -1.158000 
#>                     b_frailty             b_life_expectancy 
#>                     -0.519000                      0.360200 
#>                   b_suffering   b_disability_cardiovascular 
#>                     -0.831400                     -0.383200 
#>        b_disability_pulmonary            b_disability_renal 
#>                     -0.755200                     -0.357600 
#>     b_disability_neurological b_disability_gastrointestinal 
#>                     -0.497000                     -0.617400 
#>               b_family_values                d_asc_continue 
#>                     -2.373000                     -0.985600 
#>                d_expected_los          d_clinical_situation 
#>                      0.354200                      0.376800 
#>                         d_age                     d_frailty 
#>                     -0.086970                      0.029540 
#>             d_life_expectancy                   d_suffering 
#>                      0.026000                      0.464800 
#>   d_disability_cardiovascular        d_disability_pulmonary 
#>                     -0.002709                      0.297800 
#>            d_disability_renal     d_disability_neurological 
#>                      0.017710                      0.075050 
#> d_disability_gastrointestinal               d_family_values 
#>                      0.238300                     -0.159700 
#> 
#> For more detailed output, use summary, or apollo_modelOutput for full
#>   outputs
```
