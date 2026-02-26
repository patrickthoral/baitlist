# Fits a pooled multinomial model with interaction effects using data from both `group1` and `group2` to allow comparing difference in coefficients between groups

Fits a pooled multinomial model with interaction effects using data from
both `group1` and `group2` to allow comparing difference in coefficients
between groups

## Usage

``` r
fit_pooled_interaction_multinomial(group1, group2)
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
fit_pooled_interaction_multinomial('aumc', 'olvg')
#> 
#> Apollo model summary
#> 
#> Model name                   : baitlist_pooled_aumc_olvg
#> Model description            : Pooled multinomial logit with group interactions
#> Estimation method            : bgw
#> 
#> LL(final)                    : -710.72
#> Estimated parameters         : 40
#> 
#> Estimates:
#>                              asc_continue 
#>                                  7.730000 
#>                           asc_timelimited 
#>                                  3.838000 
#>                   b_expected_los_continue 
#>                                 -0.220200 
#>             b_clinical_situation_continue 
#>                                  1.072000 
#>                            b_age_continue 
#>                                 -1.800000 
#>                        b_frailty_continue 
#>                                 -1.088000 
#>                b_life_expectancy_continue 
#>                                  0.483800 
#>                      b_suffering_continue 
#>                                 -1.329000 
#>      b_disability_cardiovascular_continue 
#>                                 -0.824800 
#>           b_disability_pulmonary_continue 
#>                                 -1.440000 
#>               b_disability_renal_continue 
#>                                 -0.380800 
#>        b_disability_neurological_continue 
#>                                 -0.733300 
#>    b_disability_gastrointestinal_continue 
#>                                 -0.880700 
#>                  b_family_values_continue 
#>                                 -3.208000 
#>                b_expected_los_timelimited 
#>                                 -0.249400 
#>          b_clinical_situation_timelimited 
#>                                  0.093610 
#>                         b_age_timelimited 
#>                                 -0.910900 
#>                     b_frailty_timelimited 
#>                                 -0.322800 
#>             b_life_expectancy_timelimited 
#>                                  0.336000 
#>                   b_suffering_timelimited 
#>                                 -0.587700 
#>   b_disability_cardiovascular_timelimited 
#>                                 -0.195600 
#>        b_disability_pulmonary_timelimited 
#>                                 -0.507400 
#>            b_disability_renal_timelimited 
#>                                 -0.224200 
#>     b_disability_neurological_timelimited 
#>                                 -0.287900 
#> b_disability_gastrointestinal_timelimited 
#>                                 -0.488900 
#>               b_family_values_timelimited 
#>                                 -1.844000 
#>                            d_asc_continue 
#>                                 -0.908500 
#>                         d_asc_timelimited 
#>                                 -0.546800 
#>                            d_expected_los 
#>                                  0.349100 
#>                      d_clinical_situation 
#>                                  0.436000 
#>                                     d_age 
#>                                 -0.139000 
#>                                 d_frailty 
#>                                 -0.014680 
#>                         d_life_expectancy 
#>                                  0.027010 
#>                               d_suffering 
#>                                  0.417800 
#>               d_disability_cardiovascular 
#>                                 -0.046360 
#>                    d_disability_pulmonary 
#>                                  0.239800 
#>                        d_disability_renal 
#>                                 -0.004305 
#>                 d_disability_neurological 
#>                                  0.041180 
#>             d_disability_gastrointestinal 
#>                                  0.215000 
#>                           d_family_values 
#>                                 -0.260300 
#> 
#> For more detailed output, use summary, or apollo_modelOutput for full
#>   outputs
```
