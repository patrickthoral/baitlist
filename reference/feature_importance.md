# Calculates feature importance for all BAIT model types and groups using standardized coefficients and maximum utility contribution.

Standardized Coefficients (\\\beta ^{\ast }={\frac
{s\_{x}}{s\_{y}}}\beta\\) as percentage of total.

## Usage

``` r
feature_importance(
  method = "maximum_utility_contribution",
  modeltype = "binary",
  group = "aggregate"
)
```

## Arguments

- method:

  Method used for calculating feature importance. Either
  'maximum_utility_contribution' or 'standardized_coefficients'

- modeltype:

  Model type. Either 'binary' or 'multinomial'

- group:

  Participant group. One of the following 'aggregate', 'aumc', 'olvg',
  'intensivists', 'fellows'

## Details

Maximum Utility Contribution is calculated by multiplying the criteria
level range (difference between the highest and lowest level) with the
absolute value of the criterion weight. To calculate a percentage, the
maximum utility contributions are summed.

Feature importance is saved for each model as csv files in the
`inst/extdata` folder.

## Examples

``` r
baitlist::feature_importance(
  method="maximum_utility_contribution",
  modeltype="multinomial",
  group="aggregate"
  )
#> # A tibble: 24 × 6
#>    coefficient_name    coef variable alternative max_util_contrib importance_pct
#>    <chr>              <dbl> <chr>    <chr>                  <dbl>          <dbl>
#>  1 b_expected_los_… -0.0589 expecte… continue              0.0589          0.182
#>  2 b_clinical_situ…  1.25   clinica… continue              1.25            3.87 
#>  3 b_age_continue   -1.85   age      continue              5.56           17.2  
#>  4 b_frailty_conti… -1.08   frailty  continue              2.17            6.72 
#>  5 b_life_expectan…  0.487  life_ex… continue              0.973           3.01 
#>  6 b_suffering_con… -1.14   sufferi… continue              1.14            3.54 
#>  7 b_disability_ca… -0.849  disabil… continue              2.55            7.89 
#>  8 b_disability_pu… -1.33   disabil… continue              2.67            8.26 
#>  9 b_disability_re… -0.379  disabil… continue              0.758           2.35 
#> 10 b_disability_ne… -0.700  disabil… continue              1.40            4.34 
#> 11 b_disability_ga… -0.778  disabil… continue              0.778           2.41 
#> 12 b_family_values… -3.28   family_… continue              3.28           10.1  
#> 13 b_expected_los_… -0.0757 expecte… timelimited           0.0757          0.234
#> 14 b_clinical_situ…  0.282  clinica… timelimited           0.282           0.872
#> 15 b_age_timelimit… -0.971  age      timelimited           2.91            9.02 
#> 16 b_frailty_timel… -0.320  frailty  timelimited           0.641           1.98 
#> 17 b_life_expectan…  0.341  life_ex… timelimited           0.683           2.11 
#> 18 b_suffering_tim… -0.391  sufferi… timelimited           0.391           1.21 
#> 19 b_disability_ca… -0.218  disabil… timelimited           0.655           2.03 
#> 20 b_disability_pu… -0.396  disabil… timelimited           0.792           2.45 
#> 21 b_disability_re… -0.224  disabil… timelimited           0.448           1.39 
#> 22 b_disability_ne… -0.259  disabil… timelimited           0.517           1.60 
#> 23 b_disability_ga… -0.383  disabil… timelimited           0.383           1.19 
#> 24 b_family_values… -1.94   family_… timelimited           1.94            6.00 
```
