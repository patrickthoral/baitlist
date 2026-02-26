# Calculate feature importance using maximum utility contribution.

Maximum Utility Contribution is calculated by multiplying the criteria
level range (difference between the highest and lowest level) with the
absolute value of the criterion weight. To calculate a percentage, the
maximum utility contributions are summed.

## Usage

``` r
maximum_utility_contribution(modeltype = "binary", group = "aggregate")
```

## Arguments

- modeltype:

  Model type. Either 'binary' or 'multinomial'

- group:

  Participant group. One of the following 'aggregate', 'aumc', 'olvg',
  'intensivists', 'fellows'

## Examples

``` r
baitlist::maximum_utility_contribution()
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los               -0.0826 expecte…           0.0826          0.613
#>  2 b_clinical_situation          0.582  clinica…           0.582           4.32 
#>  3 b_age                        -1.19   age                3.57           26.5  
#>  4 b_frailty                    -0.496  frailty            0.992           7.36 
#>  5 b_life_expectancy             0.364  life_ex…           0.728           5.40 
#>  6 b_suffering                  -0.614  sufferi…           0.614           4.56 
#>  7 b_disability_cardiovascular  -0.385  disabil…           1.16            8.58 
#>  8 b_disability_pulmonary       -0.618  disabil…           1.24            9.18 
#>  9 b_disability_renal           -0.347  disabil…           0.693           5.14 
#> 10 b_disability_neurological    -0.451  disabil…           0.902           6.69 
#> 11 b_disability_gastrointestin… -0.503  disabil…           0.503           3.73 
#> 12 b_family_values              -2.41   family_…           2.41           17.9  
```
