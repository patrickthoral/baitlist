# Calculate feature importance using standardized coefficients

Calculates feature importance of the binary BAIT models using
standardized coefficients (\\\beta ^{\ast }={\frac
{s\_{x}}{s\_{y}}}\beta\\) as percentage of total. Feature importance is
saved for each model as csv files in the `data` folder.

## Usage

``` r
standardized_coefficients()
```

## Examples

``` r
standardized_coefficients()
#> Calculating feature importance for: All respondents
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los             0     expecte… 0.500 0.500    0               0   
#>  2 b_clinical_situation       0.586 clinica… 0.500 0.500    0.586           5.26
#>  3 b_age                     -1.19  age      1.10  0.500   -2.62           23.5 
#>  4 b_frailty                 -0.495 frailty  0.824 0.500   -0.817           7.33
#>  5 b_life_expectancy          0.361 life_ex… 0.766 0.500    0.554           4.97
#>  6 b_suffering               -0.617 sufferi… 0.500 0.500   -0.618           5.54
#>  7 b_disability_cardiovascu… -0.380 disabil… 1.10  0.500   -0.837           7.51
#>  8 b_disability_pulmonary    -0.625 disabil… 0.816 0.500   -1.02            9.16
#>  9 b_disability_renal        -0.345 disabil… 0.734 0.500   -0.507           4.55
#> 10 b_disability_neurological -0.453 disabil… 0.800 0.500   -0.726           6.51
#> 11 b_disability_gastrointes… -0.511 disabil… 0.500 0.500   -0.511           4.58
#> 12 b_family_values           -2.40  family_… 0.490 0.500   -2.35           21.1 
#> 
#> 
#> Calculating feature importance for: Amsterdam UMC
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los            -0.272 expecte… 0.500 0.499   -0.272           2.78
#>  2 b_clinical_situation       0     clinica… 0.500 0.499    0               0   
#>  3 b_age                     -1.10  age      1.10  0.499   -2.42           24.8 
#>  4 b_frailty                 -0.368 frailty  0.825 0.499   -0.607           6.20
#>  5 b_life_expectancy          0.425 life_ex… 0.766 0.499    0.653           6.67
#>  6 b_suffering               -0.571 sufferi… 0.500 0.499   -0.572           5.85
#>  7 b_disability_cardiovascu… -0.348 disabil… 1.10  0.499   -0.768           7.85
#>  8 b_disability_pulmonary    -0.680 disabil… 0.817 0.499   -1.11           11.4 
#>  9 b_disability_renal        -0.236 disabil… 0.734 0.499   -0.346           3.54
#> 10 b_disability_neurological -0.335 disabil… 0.801 0.499   -0.537           5.49
#> 11 b_disability_gastrointes… -0.449 disabil… 0.500 0.499   -0.450           4.60
#> 12 b_family_values           -2.08  family_… 0.490 0.499   -2.05           20.9 
#> 
#> 
#> Calculating feature importance for: OLVG
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los             0     expecte… 0.500 0.500    0               0   
#>  2 b_clinical_situation       0     clinica… 0.500 0.500    0               0   
#>  3 b_age                     -1.14  age      1.10  0.500   -2.52           37.6 
#>  4 b_frailty                 -0.207 frailty  0.825 0.500   -0.341           5.10
#>  5 b_life_expectancy          0.515 life_ex… 0.766 0.500    0.789          11.8 
#>  6 b_suffering                0     sufferi… 0.500 0.500    0               0   
#>  7 b_disability_cardiovascu… -0.292 disabil… 1.10  0.500   -0.643           9.61
#>  8 b_disability_pulmonary    -0.320 disabil… 0.817 0.500   -0.522           7.79
#>  9 b_disability_renal         0     disabil… 0.734 0.500    0               0   
#> 10 b_disability_neurological  0     disabil… 0.801 0.500    0               0   
#> 11 b_disability_gastrointes…  0     disabil… 0.500 0.500    0               0   
#> 12 b_family_values           -1.92  family_… 0.490 0.500   -1.89           28.2 
#> 
#> 
#> Calculating feature importance for: Intensivists
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los             0     expecte… 0.500 0.500    0               0   
#>  2 b_clinical_situation       0     clinica… 0.500 0.500    0               0   
#>  3 b_age                     -1.13  age      1.10  0.500   -2.49           34.0 
#>  4 b_frailty                 -0.106 frailty  0.824 0.500   -0.175           2.39
#>  5 b_life_expectancy          0.513 life_ex… 0.766 0.500    0.785          10.7 
#>  6 b_suffering                0     sufferi… 0.500 0.500    0               0   
#>  7 b_disability_cardiovascu… -0.380 disabil… 1.10  0.500   -0.835          11.4 
#>  8 b_disability_pulmonary    -0.442 disabil… 0.816 0.500   -0.721           9.84
#>  9 b_disability_renal        -0.198 disabil… 0.734 0.500   -0.290           3.96
#> 10 b_disability_neurological  0     disabil… 0.801 0.500    0               0   
#> 11 b_disability_gastrointes… -0.368 disabil… 0.500 0.500   -0.368           5.02
#> 12 b_family_values           -1.69  family_… 0.490 0.500   -1.66           22.7 
#> 
#> 
#> Calculating feature importance for: Fellows
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los             0.169 expecte… 0.501 0.496    0.171          0.856
#>  2 b_clinical_situation       1.63  clinica… 0.501 0.496    1.65           8.27 
#>  3 b_age                     -1.35  age      1.10  0.496   -3.01          15.1  
#>  4 b_frailty                 -1.42  frailty  0.825 0.496   -2.36          11.9  
#>  5 b_life_expectancy          0.215 life_ex… 0.767 0.496    0.333          1.67 
#>  6 b_suffering               -1.80  sufferi… 0.501 0.496   -1.81           9.10 
#>  7 b_disability_cardiovascu… -0.390 disabil… 1.10  0.496   -0.867          4.35 
#>  8 b_disability_pulmonary    -1.07  disabil… 0.817 0.496   -1.76           8.84 
#>  9 b_disability_renal        -0.546 disabil… 0.735 0.496   -0.810          4.06 
#> 10 b_disability_neurological -1.38  disabil… 0.802 0.496   -2.23          11.2  
#> 11 b_disability_gastrointes… -0.828 disabil… 0.501 0.496   -0.836          4.20 
#> 12 b_family_values           -4.13  family_… 0.491 0.496   -4.09          20.5  
#> 
#> 
```
