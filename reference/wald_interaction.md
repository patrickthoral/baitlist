# Creates a dataframe containing the Joint Wald test and Wald tests for individual coefficients in a pooled interaction model of two groups

Creates a dataframe containing the Joint Wald test and Wald tests for
individual coefficients in a pooled interaction model of two groups

## Usage

``` r
wald_interaction(group1, group2, modeltype)
```

## Arguments

- group1:

  First group

- group2:

  Second group

- modeltype:

  Model type: 'binary' or 'multinomial'

## Value

dataframe

## Examples

``` r
baitlist::wald_interaction('intensivists', 'fellows', 'binary')
#> # A tibble: 14 × 20
#>    interaction_name       wald p_raw p_value group_col coefficient_name variable
#>    <chr>                 <dbl> <dbl>   <dbl> <chr>     <chr>            <chr>   
#>  1 joint                    NA    NA      NA intensiv… NA                NA     
#>  2 d_asc_continue           NA    NA      NA intensiv… asc_continue     ""      
#>  3 d_expected_los           NA    NA      NA intensiv… b_expected_los   "expect…
#>  4 d_clinical_situation     NA    NA      NA intensiv… b_clinical_situ… "clinic…
#>  5 d_age                    NA    NA      NA intensiv… b_age            "age"   
#>  6 d_frailty                NA    NA      NA intensiv… b_frailty        "frailt…
#>  7 d_life_expectancy        NA    NA      NA intensiv… b_life_expectan… "life_e…
#>  8 d_suffering              NA    NA      NA intensiv… b_suffering      "suffer…
#>  9 d_disability_cardiov…    NA    NA      NA intensiv… b_disability_ca… "disabi…
#> 10 d_disability_pulmona…    NA    NA      NA intensiv… b_disability_pu… "disabi…
#> 11 d_disability_renal       NA    NA      NA intensiv… b_disability_re… "disabi…
#> 12 d_disability_neurolo…    NA    NA      NA intensiv… b_disability_ne… "disabi…
#> 13 d_disability_gastroi…    NA    NA      NA intensiv… b_disability_ga… "disabi…
#> 14 d_family_values          NA    NA      NA intensiv… b_family_values  "family…
#> # ℹ 13 more variables: criterion <chr>, coef_group1 <dbl>, se_group1 <lgl>,
#> #   coef_int <dbl>, se_int <lgl>, coef_group2 <dbl>, se_group2 <dbl>,
#> #   name <chr>, type <chr>, annotation <chr>, f_p_value <chr>, f_p_raw <chr>,
#> #   f_wald <chr>
```
