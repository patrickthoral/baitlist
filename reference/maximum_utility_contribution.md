# Calculate relative importance using maximum utility contribution.

Maximum Utility Contribution is calculated by multiplying the criteria
level range (difference between the highest and lowest level) with the
absolute value of the criterion weight. To calculate a percentage, the
maximum utility contributions are summed.

## Usage

``` r
maximum_utility_contribution()
```

## Examples

``` r
maximum_utility_contribution()
#> Calculating relative importance using maximum utility contribution for: All respondents
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                 0     expecte…            0               0   
#>  2 b_clinical_situation           0.586 clinica…            0.586           4.38
#>  3 b_age                         -1.19  age                 3.57           26.7 
#>  4 b_frailty                     -0.495 frailty             0.990           7.40
#>  5 b_life_expectancy              0.361 life_ex…            0.723           5.40
#>  6 b_suffering                   -0.617 sufferi…            0.617           4.61
#>  7 b_disability_cardiovascular   -0.380 disabil…            1.14            8.52
#>  8 b_disability_pulmonary        -0.625 disabil…            1.25            9.34
#>  9 b_disability_renal            -0.345 disabil…            0.690           5.16
#> 10 b_disability_neurological     -0.453 disabil…            0.906           6.77
#> 11 b_disability_gastrointestinal -0.511 disabil…            0.511           3.82
#> 12 b_family_values               -2.40  family_…            2.40           17.9 
#> 
#> 
#> Calculating relative importance using maximum utility contribution for: Amsterdam UMC
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                -0.272 expecte…            0.272           2.30
#>  2 b_clinical_situation           0     clinica…            0               0   
#>  3 b_age                         -1.10  age                 3.30           27.9 
#>  4 b_frailty                     -0.368 frailty             0.736           6.23
#>  5 b_life_expectancy              0.425 life_ex…            0.851           7.21
#>  6 b_suffering                   -0.571 sufferi…            0.571           4.84
#>  7 b_disability_cardiovascular   -0.348 disabil…            1.05            8.85
#>  8 b_disability_pulmonary        -0.680 disabil…            1.36           11.5 
#>  9 b_disability_renal            -0.236 disabil…            0.471           3.99
#> 10 b_disability_neurological     -0.335 disabil…            0.670           5.67
#> 11 b_disability_gastrointestinal -0.449 disabil…            0.449           3.81
#> 12 b_family_values               -2.08  family_…            2.08           17.6 
#> 
#> 
#> Calculating relative importance using maximum utility contribution for: OLVG
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                 0     expecte…            0               0   
#>  2 b_clinical_situation           0     clinica…            0               0   
#>  3 b_age                         -1.14  age                 3.43           41.2 
#>  4 b_frailty                     -0.207 frailty             0.414           4.98
#>  5 b_life_expectancy              0.515 life_ex…            1.03           12.4 
#>  6 b_suffering                    0     sufferi…            0               0   
#>  7 b_disability_cardiovascular   -0.292 disabil…            0.877          10.6 
#>  8 b_disability_pulmonary        -0.320 disabil…            0.639           7.69
#>  9 b_disability_renal             0     disabil…            0               0   
#> 10 b_disability_neurological      0     disabil…            0               0   
#> 11 b_disability_gastrointestinal  0     disabil…            0               0   
#> 12 b_family_values               -1.92  family_…            1.92           23.1 
#> 
#> 
#> Calculating relative importance using maximum utility contribution for: Intensivists
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                 0     expecte…            0               0   
#>  2 b_clinical_situation           0     clinica…            0               0   
#>  3 b_age                         -1.13  age                 3.40           37.3 
#>  4 b_frailty                     -0.106 frailty             0.213           2.33
#>  5 b_life_expectancy              0.513 life_ex…            1.03           11.2 
#>  6 b_suffering                    0     sufferi…            0               0   
#>  7 b_disability_cardiovascular   -0.380 disabil…            1.14           12.5 
#>  8 b_disability_pulmonary        -0.442 disabil…            0.884           9.69
#>  9 b_disability_renal            -0.198 disabil…            0.395           4.34
#> 10 b_disability_neurological      0     disabil…            0               0   
#> 11 b_disability_gastrointestinal -0.368 disabil…            0.368           4.03
#> 12 b_family_values               -1.69  family_…            1.69           18.6 
#> 
#> 
#> Calculating relative importance using maximum utility contribution for: Fellows
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                 0.169 expecte…            0.169          0.734
#>  2 b_clinical_situation           1.63  clinica…            1.63           7.08 
#>  3 b_age                         -1.35  age                 4.06          17.6  
#>  4 b_frailty                     -1.42  frailty             2.84          12.3  
#>  5 b_life_expectancy              0.215 life_ex…            0.430          1.87 
#>  6 b_suffering                   -1.80  sufferi…            1.80           7.79 
#>  7 b_disability_cardiovascular   -0.390 disabil…            1.17           5.08 
#>  8 b_disability_pulmonary        -1.07  disabil…            2.14           9.27 
#>  9 b_disability_renal            -0.546 disabil…            1.09           4.74 
#> 10 b_disability_neurological     -1.38  disabil…            2.76          12.0  
#> 11 b_disability_gastrointestinal -0.828 disabil…            0.828          3.59 
#> 12 b_family_values               -4.13  family_…            4.13          17.9  
#> 
#> 
```
