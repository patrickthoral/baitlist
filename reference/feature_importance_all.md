# Calculates feature importance for all BAIT model types and groups using standardized coefficients and maximum utility contribution.

Standardized Coefficients (\\\beta ^{\ast }={\frac
{s\_{x}}{s\_{y}}}\beta\\) as percentage of total.

## Usage

``` r
feature_importance_all()
```

## Details

Maximum Utility Contribution is calculated by multiplying the criteria
level range (difference between the highest and lowest level) with the
absolute value of the criterion weight. To calculate a percentage, the
maximum utility contributions are summed.

Feature importance is saved for each model as csv files in the
`inst/extdata` folder.

## Examples

``` r
baitlist::feature_importance_all()
#> Calculating feature importance using Standardized Coefficients for: All respondents
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los           -0.0826 expecte… 0.500 0.885  -0.0466          0.735
#>  2 b_clinical_situation      0.582  clinica… 0.500 0.885   0.329           5.18 
#>  3 b_age                    -1.19   age      1.10  0.885  -1.48           23.3  
#>  4 b_frailty                -0.496  frailty  0.824 0.885  -0.462           7.28 
#>  5 b_life_expectancy         0.364  life_ex… 0.766 0.885   0.315           4.97 
#>  6 b_suffering              -0.614  sufferi… 0.500 0.885  -0.347           5.47 
#>  7 b_disability_cardiovasc… -0.385  disabil… 1.10  0.885  -0.479           7.55 
#>  8 b_disability_pulmonary   -0.618  disabil… 0.816 0.885  -0.570           8.99 
#>  9 b_disability_renal       -0.347  disabil… 0.734 0.885  -0.287           4.53 
#> 10 b_disability_neurologic… -0.451  disabil… 0.800 0.885  -0.408           6.43 
#> 11 b_disability_gastrointe… -0.503  disabil… 0.500 0.885  -0.284           4.48 
#> 12 b_family_values          -2.41   family_… 0.490 0.885  -1.34           21.1  
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: Amsterdam UMC
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los            -0.257 expecte… 0.500 0.875   -0.147           2.18
#>  2 b_clinical_situation       0.425 clinica… 0.500 0.875    0.243           3.60
#>  3 b_age                     -1.16  age      1.10  0.875   -1.46           21.6 
#>  4 b_frailty                 -0.519 frailty  0.825 0.875   -0.489           7.24
#>  5 b_life_expectancy          0.360 life_ex… 0.766 0.875    0.315           4.67
#>  6 b_suffering               -0.831 sufferi… 0.500 0.875   -0.475           7.04
#>  7 b_disability_cardiovascu… -0.383 disabil… 1.10  0.875   -0.482           7.14
#>  8 b_disability_pulmonary    -0.755 disabil… 0.817 0.875   -0.705          10.4 
#>  9 b_disability_renal        -0.358 disabil… 0.734 0.875   -0.300           4.44
#> 10 b_disability_neurological -0.497 disabil… 0.801 0.875   -0.455           6.74
#> 11 b_disability_gastrointes… -0.617 disabil… 0.500 0.875   -0.353           5.23
#> 12 b_family_values           -2.37  family_… 0.490 0.875   -1.33           19.7 
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: OLVG
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los            0.0970 expecte… 0.500 0.897   0.0541          0.879
#>  2 b_clinical_situation      0.802  clinica… 0.500 0.897   0.447           7.27 
#>  3 b_age                    -1.24   age      1.10  0.897  -1.53           24.8  
#>  4 b_frailty                -0.489  frailty  0.825 0.897  -0.450           7.31 
#>  5 b_life_expectancy         0.386  life_ex… 0.766 0.897   0.330           5.36 
#>  6 b_suffering              -0.367  sufferi… 0.500 0.897  -0.204           3.32 
#>  7 b_disability_cardiovasc… -0.386  disabil… 1.10  0.897  -0.473           7.70 
#>  8 b_disability_pulmonary   -0.457  disabil… 0.817 0.897  -0.416           6.77 
#>  9 b_disability_renal       -0.340  disabil… 0.734 0.897  -0.278           4.52 
#> 10 b_disability_neurologic… -0.422  disabil… 0.801 0.897  -0.377           6.12 
#> 11 b_disability_gastrointe… -0.379  disabil… 0.500 0.897  -0.211           3.43 
#> 12 b_family_values          -2.53   family_… 0.490 0.897  -1.38           22.5  
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: Intensivists
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los            -0.201 expecte… 0.500 0.875   -0.115           2.09
#>  2 b_clinical_situation       0.322 clinica… 0.500 0.875    0.184           3.36
#>  3 b_age                     -1.19  age      1.10  0.875   -1.49           27.2 
#>  4 b_frailty                 -0.262 frailty  0.824 0.875   -0.247           4.50
#>  5 b_life_expectancy          0.450 life_ex… 0.766 0.875    0.393           7.18
#>  6 b_suffering               -0.299 sufferi… 0.500 0.875   -0.171           3.11
#>  7 b_disability_cardiovascu… -0.420 disabil… 1.10  0.875   -0.528           9.63
#>  8 b_disability_pulmonary    -0.504 disabil… 0.816 0.875   -0.470           8.57
#>  9 b_disability_renal        -0.324 disabil… 0.734 0.875   -0.272           4.96
#> 10 b_disability_neurological -0.226 disabil… 0.801 0.875   -0.207           3.78
#> 11 b_disability_gastrointes… -0.483 disabil… 0.500 0.875   -0.276           5.04
#> 12 b_family_values           -2.01  family_… 0.490 0.875   -1.13           20.6 
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: Fellows
#> # A tibble: 12 × 7
#>    coefficient_name            coef variable  sd_x  sd_y std_coef importance_pct
#>    <chr>                      <dbl> <chr>    <dbl> <dbl>    <dbl>          <dbl>
#>  1 b_expected_los             0.169 expecte… 0.501 0.904   0.0936          0.856
#>  2 b_clinical_situation       1.63  clinica… 0.501 0.904   0.903           8.27 
#>  3 b_age                     -1.35  age      1.10  0.904  -1.65           15.1  
#>  4 b_frailty                 -1.42  frailty  0.825 0.904  -1.30           11.9  
#>  5 b_life_expectancy          0.215 life_ex… 0.767 0.904   0.182           1.67 
#>  6 b_suffering               -1.80  sufferi… 0.501 0.904  -0.994           9.10 
#>  7 b_disability_cardiovascu… -0.390 disabil… 1.10  0.904  -0.475           4.35 
#>  8 b_disability_pulmonary    -1.07  disabil… 0.817 0.904  -0.966           8.84 
#>  9 b_disability_renal        -0.546 disabil… 0.735 0.904  -0.444           4.06 
#> 10 b_disability_neurological -1.38  disabil… 0.802 0.904  -1.22           11.2  
#> 11 b_disability_gastrointes… -0.828 disabil… 0.501 0.904  -0.458           4.20 
#> 12 b_family_values           -4.13  family_… 0.491 0.904  -2.24           20.5  
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: All respondents
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
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: Amsterdam UMC
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                -0.257 expecte…            0.257           1.82
#>  2 b_clinical_situation           0.425 clinica…            0.425           3.01
#>  3 b_age                         -1.16  age                 3.47           24.6 
#>  4 b_frailty                     -0.519 frailty             1.04            7.36
#>  5 b_life_expectancy              0.360 life_ex…            0.720           5.11
#>  6 b_suffering                   -0.831 sufferi…            0.831           5.89
#>  7 b_disability_cardiovascular   -0.383 disabil…            1.15            8.15
#>  8 b_disability_pulmonary        -0.755 disabil…            1.51           10.7 
#>  9 b_disability_renal            -0.358 disabil…            0.715           5.07
#> 10 b_disability_neurological     -0.497 disabil…            0.994           7.05
#> 11 b_disability_gastrointestinal -0.617 disabil…            0.617           4.38
#> 12 b_family_values               -2.37  family_…            2.37           16.8 
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: OLVG
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                0.0970 expecte…           0.0970          0.732
#>  2 b_clinical_situation          0.802  clinica…           0.802           6.05 
#>  3 b_age                        -1.24   age                3.73           28.2  
#>  4 b_frailty                    -0.489  frailty            0.979           7.38 
#>  5 b_life_expectancy             0.386  life_ex…           0.772           5.83 
#>  6 b_suffering                  -0.367  sufferi…           0.367           2.76 
#>  7 b_disability_cardiovascular  -0.386  disabil…           1.16            8.73 
#>  8 b_disability_pulmonary       -0.457  disabil…           0.915           6.90 
#>  9 b_disability_renal           -0.340  disabil…           0.680           5.13 
#> 10 b_disability_neurological    -0.422  disabil…           0.844           6.36 
#> 11 b_disability_gastrointestin… -0.379  disabil…           0.379           2.86 
#> 12 b_family_values              -2.53   family_…           2.53           19.1  
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: Intensivists
#> # A tibble: 12 × 5
#>    coefficient_name                coef variable max_util_contrib importance_pct
#>    <chr>                          <dbl> <chr>               <dbl>          <dbl>
#>  1 b_expected_los                -0.201 expecte…            0.201           1.72
#>  2 b_clinical_situation           0.322 clinica…            0.322           2.76
#>  3 b_age                         -1.19  age                 3.56           30.5 
#>  4 b_frailty                     -0.262 frailty             0.524           4.49
#>  5 b_life_expectancy              0.450 life_ex…            0.899           7.71
#>  6 b_suffering                   -0.299 sufferi…            0.299           2.56
#>  7 b_disability_cardiovascular   -0.420 disabil…            1.26           10.8 
#>  8 b_disability_pulmonary        -0.504 disabil…            1.01            8.64
#>  9 b_disability_renal            -0.324 disabil…            0.648           5.56
#> 10 b_disability_neurological     -0.226 disabil…            0.453           3.88
#> 11 b_disability_gastrointestinal -0.483 disabil…            0.483           4.14
#> 12 b_family_values               -2.01  family_…            2.01           17.3 
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: Fellows
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
#> Calculating feature importance using Standardized Coefficients for: All respondents
#> # A tibble: 24 × 8
#>    coefficient_name               coef variable alternative  sd_x  sd_y std_coef
#>    <chr>                         <dbl> <chr>    <chr>       <dbl> <dbl>    <dbl>
#>  1 b_expected_los_continue     -0.0589 expecte… continue    0.500 0.885  -0.0333
#>  2 b_clinical_situation_conti…  1.25   clinica… continue    0.500 0.885   0.706 
#>  3 b_age_continue              -1.85   age      continue    1.10  0.885  -2.30  
#>  4 b_frailty_continue          -1.08   frailty  continue    0.824 0.885  -1.01  
#>  5 b_life_expectancy_continue   0.487  life_ex… continue    0.766 0.885   0.421 
#>  6 b_suffering_continue        -1.14   sufferi… continue    0.500 0.885  -0.645 
#>  7 b_disability_cardiovascula… -0.849  disabil… continue    1.10  0.885  -1.06  
#>  8 b_disability_pulmonary_con… -1.33   disabil… continue    0.816 0.885  -1.23  
#>  9 b_disability_renal_continue -0.379  disabil… continue    0.734 0.885  -0.314 
#> 10 b_disability_neurological_… -0.700  disabil… continue    0.800 0.885  -0.633 
#> 11 b_disability_gastrointesti… -0.778  disabil… continue    0.500 0.885  -0.440 
#> 12 b_family_values_continue    -3.28   family_… continue    0.490 0.885  -1.81  
#> 13 b_expected_los_timelimited  -0.0757 expecte… timelimited 0.500 0.885  -0.0427
#> 14 b_clinical_situation_timel…  0.282  clinica… timelimited 0.500 0.885   0.159 
#> 15 b_age_timelimited           -0.971  age      timelimited 1.10  0.885  -1.21  
#> 16 b_frailty_timelimited       -0.320  frailty  timelimited 0.824 0.885  -0.298 
#> 17 b_life_expectancy_timelimi…  0.341  life_ex… timelimited 0.766 0.885   0.295 
#> 18 b_suffering_timelimited     -0.391  sufferi… timelimited 0.500 0.885  -0.221 
#> 19 b_disability_cardiovascula… -0.218  disabil… timelimited 1.10  0.885  -0.271 
#> 20 b_disability_pulmonary_tim… -0.396  disabil… timelimited 0.816 0.885  -0.365 
#> 21 b_disability_renal_timelim… -0.224  disabil… timelimited 0.734 0.885  -0.186 
#> 22 b_disability_neurological_… -0.259  disabil… timelimited 0.800 0.885  -0.234 
#> 23 b_disability_gastrointesti… -0.383  disabil… timelimited 0.500 0.885  -0.216 
#> 24 b_family_values_timelimited -1.94   family_… timelimited 0.490 0.885  -1.07  
#> # ℹ 1 more variable: importance_pct <dbl>
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: Amsterdam UMC
#> # A tibble: 24 × 8
#>    coefficient_name               coef variable alternative  sd_x  sd_y std_coef
#>    <chr>                         <dbl> <chr>    <chr>       <dbl> <dbl>    <dbl>
#>  1 b_expected_los_continue      -0.316 expecte… continue    0.500 0.875  -0.181 
#>  2 b_clinical_situation_contin…  1.06  clinica… continue    0.500 0.875   0.608 
#>  3 b_age_continue               -1.73  age      continue    1.10  0.875  -2.18  
#>  4 b_frailty_continue           -1.04  frailty  continue    0.825 0.875  -0.977 
#>  5 b_life_expectancy_continue    0.418 life_ex… continue    0.766 0.875   0.366 
#>  6 b_suffering_continue         -1.19  sufferi… continue    0.500 0.875  -0.678 
#>  7 b_disability_cardiovascular… -0.795 disabil… continue    1.10  0.875  -1.00  
#>  8 b_disability_pulmonary_cont… -1.49  disabil… continue    0.817 0.875  -1.39  
#>  9 b_disability_renal_continue  -0.597 disabil… continue    0.734 0.875  -0.501 
#> 10 b_disability_neurological_c… -0.754 disabil… continue    0.801 0.875  -0.690 
#> 11 b_disability_gastrointestin… -0.945 disabil… continue    0.500 0.875  -0.540 
#> 12 b_family_values_continue     -3.21  family_… continue    0.490 0.875  -1.80  
#> 13 b_expected_los_timelimited   -0.185 expecte… timelimited 0.500 0.875  -0.105 
#> 14 b_clinical_situation_timeli…  0.133 clinica… timelimited 0.500 0.875   0.0759
#> 15 b_age_timelimited            -0.922 age      timelimited 1.10  0.875  -1.16  
#> 16 b_frailty_timelimited        -0.332 frailty  timelimited 0.825 0.875  -0.313 
#> 17 b_life_expectancy_timelimit…  0.355 life_ex… timelimited 0.766 0.875   0.311 
#> 18 b_suffering_timelimited      -0.659 sufferi… timelimited 0.500 0.875  -0.377 
#> 19 b_disability_cardiovascular… -0.190 disabil… timelimited 1.10  0.875  -0.239 
#> 20 b_disability_pulmonary_time… -0.479 disabil… timelimited 0.817 0.875  -0.447 
#> 21 b_disability_renal_timelimi… -0.173 disabil… timelimited 0.734 0.875  -0.145 
#> 22 b_disability_neurological_t… -0.301 disabil… timelimited 0.801 0.875  -0.276 
#> 23 b_disability_gastrointestin… -0.474 disabil… timelimited 0.500 0.875  -0.271 
#> 24 b_family_values_timelimited  -1.88  family_… timelimited 0.490 0.875  -1.05  
#> # ℹ 1 more variable: importance_pct <dbl>
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: OLVG
#> # A tibble: 24 × 8
#>    coefficient_name               coef variable alternative  sd_x  sd_y std_coef
#>    <chr>                         <dbl> <chr>    <chr>       <dbl> <dbl>    <dbl>
#>  1 b_expected_los_continue      0.303  expecte… continue    0.500 0.897   0.169 
#>  2 b_clinical_situation_conti…  1.49   clinica… continue    0.500 0.897   0.832 
#>  3 b_age_continue              -2.10   age      continue    1.10  0.897  -2.58  
#>  4 b_frailty_continue          -1.24   frailty  continue    0.825 0.897  -1.14  
#>  5 b_life_expectancy_continue   0.564  life_ex… continue    0.766 0.897   0.481 
#>  6 b_suffering_continue        -1.13   sufferi… continue    0.500 0.897  -0.630 
#>  7 b_disability_cardiovascula… -0.950  disabil… continue    1.10  0.897  -1.17  
#>  8 b_disability_pulmonary_con… -1.14   disabil… continue    0.817 0.897  -1.03  
#>  9 b_disability_renal_continue -0.0184 disabil… continue    0.734 0.897  -0.0150
#> 10 b_disability_neurological_… -0.730  disabil… continue    0.801 0.897  -0.651 
#> 11 b_disability_gastrointesti… -0.557  disabil… continue    0.500 0.897  -0.311 
#> 12 b_family_values_continue    -3.52   family_… continue    0.490 0.897  -1.92  
#> 13 b_expected_los_timelimited   0.0324 expecte… timelimited 0.500 0.897   0.0180
#> 14 b_clinical_situation_timel…  0.491  clinica… timelimited 0.500 0.897   0.274 
#> 15 b_age_timelimited           -1.04   age      timelimited 1.10  0.897  -1.27  
#> 16 b_frailty_timelimited       -0.326  frailty  timelimited 0.825 0.897  -0.300 
#> 17 b_life_expectancy_timelimi…  0.351  life_ex… timelimited 0.766 0.897   0.299 
#> 18 b_suffering_timelimited     -0.102  sufferi… timelimited 0.500 0.897  -0.0570
#> 19 b_disability_cardiovascula… -0.250  disabil… timelimited 1.10  0.897  -0.307 
#> 20 b_disability_pulmonary_tim… -0.298  disabil… timelimited 0.817 0.897  -0.271 
#> 21 b_disability_renal_timelim… -0.283  disabil… timelimited 0.734 0.897  -0.231 
#> 22 b_disability_neurological_… -0.229  disabil… timelimited 0.801 0.897  -0.204 
#> 23 b_disability_gastrointesti… -0.303  disabil… timelimited 0.500 0.897  -0.169 
#> 24 b_family_values_timelimited -2.07   family_… timelimited 0.490 0.897  -1.13  
#> # ℹ 1 more variable: importance_pct <dbl>
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: Intensivists
#> # A tibble: 24 × 8
#>    coefficient_name               coef variable alternative  sd_x  sd_y std_coef
#>    <chr>                         <dbl> <chr>    <chr>       <dbl> <dbl>    <dbl>
#>  1 b_expected_los_continue     -0.101  expecte… continue    0.500 0.875  -0.0580
#>  2 b_clinical_situation_conti…  0.824  clinica… continue    0.500 0.875   0.471 
#>  3 b_age_continue              -1.76   age      continue    1.10  0.875  -2.22  
#>  4 b_frailty_continue          -0.699  frailty  continue    0.824 0.875  -0.658 
#>  5 b_life_expectancy_continue   0.638  life_ex… continue    0.766 0.875   0.558 
#>  6 b_suffering_continue        -0.716  sufferi… continue    0.500 0.875  -0.409 
#>  7 b_disability_cardiovascula… -0.771  disabil… continue    1.10  0.875  -0.970 
#>  8 b_disability_pulmonary_con… -1.07   disabil… continue    0.816 0.875  -0.995 
#>  9 b_disability_renal_continue -0.312  disabil… continue    0.734 0.875  -0.262 
#> 10 b_disability_neurological_… -0.370  disabil… continue    0.801 0.875  -0.338 
#> 11 b_disability_gastrointesti… -0.773  disabil… continue    0.500 0.875  -0.442 
#> 12 b_family_values_continue    -2.88   family_… continue    0.490 0.875  -1.61  
#> 13 b_expected_los_timelimited  -0.222  expecte… timelimited 0.500 0.875  -0.127 
#> 14 b_clinical_situation_timel…  0.0228 clinica… timelimited 0.500 0.875   0.0130
#> 15 b_age_timelimited           -0.956  age      timelimited 1.10  0.875  -1.20  
#> 16 b_frailty_timelimited       -0.0906 frailty  timelimited 0.824 0.875  -0.0853
#> 17 b_life_expectancy_timelimi…  0.409  life_ex… timelimited 0.766 0.875   0.358 
#> 18 b_suffering_timelimited     -0.0599 sufferi… timelimited 0.500 0.875  -0.0342
#> 19 b_disability_cardiovascula… -0.263  disabil… timelimited 1.10  0.875  -0.331 
#> 20 b_disability_pulmonary_tim… -0.291  disabil… timelimited 0.816 0.875  -0.272 
#> 21 b_disability_renal_timelim… -0.223  disabil… timelimited 0.734 0.875  -0.187 
#> 22 b_disability_neurological_… -0.0461 disabil… timelimited 0.801 0.875  -0.0421
#> 23 b_disability_gastrointesti… -0.349  disabil… timelimited 0.500 0.875  -0.199 
#> 24 b_family_values_timelimited -1.51   family_… timelimited 0.490 0.875  -0.844 
#> # ℹ 1 more variable: importance_pct <dbl>
#> 
#> 
#> Calculating feature importance using Standardized Coefficients for: Fellows
#> # A tibble: 24 × 8
#>    coefficient_name               coef variable alternative  sd_x  sd_y std_coef
#>    <chr>                         <dbl> <chr>    <chr>       <dbl> <dbl>    <dbl>
#>  1 b_expected_los_continue     -0.228  expecte… continue    0.501 0.904  -0.126 
#>  2 b_clinical_situation_conti…  2.92   clinica… continue    0.501 0.904   1.62  
#>  3 b_age_continue              -2.79   age      continue    1.10  0.904  -3.40  
#>  4 b_frailty_continue          -3.08   frailty  continue    0.825 0.904  -2.81  
#>  5 b_life_expectancy_continue   0.0493 life_ex… continue    0.767 0.904   0.0418
#>  6 b_suffering_continue        -3.26   sufferi… continue    0.501 0.904  -1.81  
#>  7 b_disability_cardiovascula… -1.60   disabil… continue    1.10  0.904  -1.95  
#>  8 b_disability_pulmonary_con… -2.71   disabil… continue    0.817 0.904  -2.45  
#>  9 b_disability_renal_continue -0.344  disabil… continue    0.735 0.904  -0.280 
#> 10 b_disability_neurological_… -2.29   disabil… continue    0.802 0.904  -2.03  
#> 11 b_disability_gastrointesti… -0.787  disabil… continue    0.501 0.904  -0.436 
#> 12 b_family_values_continue    -5.06   family_… continue    0.491 0.904  -2.75  
#> 13 b_expected_los_timelimited   0.208  expecte… timelimited 0.501 0.904   0.115 
#> 14 b_clinical_situation_timel…  1.41   clinica… timelimited 0.501 0.904   0.781 
#> 15 b_age_timelimited           -1.18   age      timelimited 1.10  0.904  -1.43  
#> 16 b_frailty_timelimited       -1.25   frailty  timelimited 0.825 0.904  -1.14  
#> 17 b_life_expectancy_timelimi…  0.252  life_ex… timelimited 0.767 0.904   0.214 
#> 18 b_suffering_timelimited     -1.63   sufferi… timelimited 0.501 0.904  -0.900 
#> 19 b_disability_cardiovascula… -0.220  disabil… timelimited 1.10  0.904  -0.268 
#> 20 b_disability_pulmonary_tim… -0.832  disabil… timelimited 0.817 0.904  -0.752 
#> 21 b_disability_renal_timelim… -0.417  disabil… timelimited 0.735 0.904  -0.339 
#> 22 b_disability_neurological_… -1.18   disabil… timelimited 0.802 0.904  -1.05  
#> 23 b_disability_gastrointesti… -0.763  disabil… timelimited 0.501 0.904  -0.423 
#> 24 b_family_values_timelimited -3.78   family_… timelimited 0.491 0.904  -2.05  
#> # ℹ 1 more variable: importance_pct <dbl>
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: All respondents
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
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: Amsterdam UMC
#> # A tibble: 24 × 6
#>    coefficient_name    coef variable alternative max_util_contrib importance_pct
#>    <chr>              <dbl> <chr>    <chr>                  <dbl>          <dbl>
#>  1 b_expected_los_c… -0.316 expecte… continue               0.316          0.963
#>  2 b_clinical_situa…  1.06  clinica… continue               1.06           3.24 
#>  3 b_age_continue    -1.73  age      continue               5.20          15.8  
#>  4 b_frailty_contin… -1.04  frailty  continue               2.07           6.31 
#>  5 b_life_expectanc…  0.418 life_ex… continue               0.837          2.55 
#>  6 b_suffering_cont… -1.19  sufferi… continue               1.19           3.61 
#>  7 b_disability_car… -0.795 disabil… continue               2.39           7.26 
#>  8 b_disability_pul… -1.49  disabil… continue               2.98           9.08 
#>  9 b_disability_ren… -0.597 disabil… continue               1.19           3.64 
#> 10 b_disability_neu… -0.754 disabil… continue               1.51           4.59 
#> 11 b_disability_gas… -0.945 disabil… continue               0.945          2.88 
#> 12 b_family_values_… -3.21  family_… continue               3.21           9.76 
#> 13 b_expected_los_t… -0.185 expecte… timelimited            0.185          0.562
#> 14 b_clinical_situa…  0.133 clinica… timelimited            0.133          0.405
#> 15 b_age_timelimited -0.922 age      timelimited            2.77           8.43 
#> 16 b_frailty_timeli… -0.332 frailty  timelimited            0.664          2.02 
#> 17 b_life_expectanc…  0.355 life_ex… timelimited            0.710          2.16 
#> 18 b_suffering_time… -0.659 sufferi… timelimited            0.659          2.01 
#> 19 b_disability_car… -0.190 disabil… timelimited            0.571          1.74 
#> 20 b_disability_pul… -0.479 disabil… timelimited            0.958          2.92 
#> 21 b_disability_ren… -0.173 disabil… timelimited            0.347          1.06 
#> 22 b_disability_neu… -0.301 disabil… timelimited            0.602          1.83 
#> 23 b_disability_gas… -0.474 disabil… timelimited            0.474          1.44 
#> 24 b_family_values_… -1.88  family_… timelimited            1.88           5.71 
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: OLVG
#> # A tibble: 24 × 6
#>    coefficient_name    coef variable alternative max_util_contrib importance_pct
#>    <chr>              <dbl> <chr>    <chr>                  <dbl>          <dbl>
#>  1 b_expected_los_…  0.303  expecte… continue              0.303          0.909 
#>  2 b_clinical_situ…  1.49   clinica… continue              1.49           4.47  
#>  3 b_age_continue   -2.10   age      continue              6.31          18.9   
#>  4 b_frailty_conti… -1.24   frailty  continue              2.48           7.44  
#>  5 b_life_expectan…  0.564  life_ex… continue              1.13           3.38  
#>  6 b_suffering_con… -1.13   sufferi… continue              1.13           3.39  
#>  7 b_disability_ca… -0.950  disabil… continue              2.85           8.54  
#>  8 b_disability_pu… -1.14   disabil… continue              2.27           6.80  
#>  9 b_disability_re… -0.0184 disabil… continue              0.0367         0.110 
#> 10 b_disability_ne… -0.730  disabil… continue              1.46           4.37  
#> 11 b_disability_ga… -0.557  disabil… continue              0.557          1.67  
#> 12 b_family_values… -3.52   family_… continue              3.52          10.6   
#> 13 b_expected_los_…  0.0324 expecte… timelimited           0.0324         0.0970
#> 14 b_clinical_situ…  0.491  clinica… timelimited           0.491          1.47  
#> 15 b_age_timelimit… -1.04   age      timelimited           3.11           9.31  
#> 16 b_frailty_timel… -0.326  frailty  timelimited           0.653          1.96  
#> 17 b_life_expectan…  0.351  life_ex… timelimited           0.701          2.10  
#> 18 b_suffering_tim… -0.102  sufferi… timelimited           0.102          0.307 
#> 19 b_disability_ca… -0.250  disabil… timelimited           0.750          2.25  
#> 20 b_disability_pu… -0.298  disabil… timelimited           0.596          1.79  
#> 21 b_disability_re… -0.283  disabil… timelimited           0.566          1.70  
#> 22 b_disability_ne… -0.229  disabil… timelimited           0.457          1.37  
#> 23 b_disability_ga… -0.303  disabil… timelimited           0.303          0.908 
#> 24 b_family_values… -2.07   family_… timelimited           2.07           6.20  
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: Intensivists
#> # A tibble: 24 × 6
#>    coefficient_name    coef variable alternative max_util_contrib importance_pct
#>    <chr>              <dbl> <chr>    <chr>                  <dbl>          <dbl>
#>  1 b_expected_los_… -0.101  expecte… continue              0.101          0.376 
#>  2 b_clinical_situ…  0.824  clinica… continue              0.824          3.05  
#>  3 b_age_continue   -1.76   age      continue              5.29          19.6   
#>  4 b_frailty_conti… -0.699  frailty  continue              1.40           5.18  
#>  5 b_life_expectan…  0.638  life_ex… continue              1.28           4.73  
#>  6 b_suffering_con… -0.716  sufferi… continue              0.716          2.65  
#>  7 b_disability_ca… -0.771  disabil… continue              2.31           8.57  
#>  8 b_disability_pu… -1.07   disabil… continue              2.13           7.90  
#>  9 b_disability_re… -0.312  disabil… continue              0.624          2.31  
#> 10 b_disability_ne… -0.370  disabil… continue              0.739          2.74  
#> 11 b_disability_ga… -0.773  disabil… continue              0.773          2.86  
#> 12 b_family_values… -2.88   family_… continue              2.88          10.7   
#> 13 b_expected_los_… -0.222  expecte… timelimited           0.222          0.824 
#> 14 b_clinical_situ…  0.0228 clinica… timelimited           0.0228         0.0844
#> 15 b_age_timelimit… -0.956  age      timelimited           2.87          10.6   
#> 16 b_frailty_timel… -0.0906 frailty  timelimited           0.181          0.671 
#> 17 b_life_expectan…  0.409  life_ex… timelimited           0.818          3.03  
#> 18 b_suffering_tim… -0.0599 sufferi… timelimited           0.0599         0.222 
#> 19 b_disability_ca… -0.263  disabil… timelimited           0.790          2.93  
#> 20 b_disability_pu… -0.291  disabil… timelimited           0.583          2.16  
#> 21 b_disability_re… -0.223  disabil… timelimited           0.445          1.65  
#> 22 b_disability_ne… -0.0461 disabil… timelimited           0.0921         0.341 
#> 23 b_disability_ga… -0.349  disabil… timelimited           0.349          1.29  
#> 24 b_family_values… -1.51   family_… timelimited           1.51           5.58  
#> 
#> 
#> Calculating feature importance using Maximum Utility Contribution for: Fellows
#> # A tibble: 24 × 6
#>    coefficient_name    coef variable alternative max_util_contrib importance_pct
#>    <chr>              <dbl> <chr>    <chr>                  <dbl>          <dbl>
#>  1 b_expected_los_… -0.228  expecte… continue              0.228           0.366
#>  2 b_clinical_situ…  2.92   clinica… continue              2.92            4.70 
#>  3 b_age_continue   -2.79   age      continue              8.36           13.4  
#>  4 b_frailty_conti… -3.08   frailty  continue              6.16            9.90 
#>  5 b_life_expectan…  0.0493 life_ex… continue              0.0987          0.159
#>  6 b_suffering_con… -3.26   sufferi… continue              3.26            5.24 
#>  7 b_disability_ca… -1.60   disabil… continue              4.81            7.73 
#>  8 b_disability_pu… -2.71   disabil… continue              5.41            8.70 
#>  9 b_disability_re… -0.344  disabil… continue              0.688           1.11 
#> 10 b_disability_ne… -2.29   disabil… continue              4.58            7.36 
#> 11 b_disability_ga… -0.787  disabil… continue              0.787           1.27 
#> 12 b_family_values… -5.06   family_… continue              5.06            8.14 
#> 13 b_expected_los_…  0.208  expecte… timelimited           0.208           0.334
#> 14 b_clinical_situ…  1.41   clinica… timelimited           1.41            2.27 
#> 15 b_age_timelimit… -1.18   age      timelimited           3.53            5.67 
#> 16 b_frailty_timel… -1.25   frailty  timelimited           2.49            4.01 
#> 17 b_life_expectan…  0.252  life_ex… timelimited           0.504           0.810
#> 18 b_suffering_tim… -1.63   sufferi… timelimited           1.63            2.61 
#> 19 b_disability_ca… -0.220  disabil… timelimited           0.661           1.06 
#> 20 b_disability_pu… -0.832  disabil… timelimited           1.66            2.67 
#> 21 b_disability_re… -0.417  disabil… timelimited           0.834           1.34 
#> 22 b_disability_ne… -1.18   disabil… timelimited           2.36            3.80 
#> 23 b_disability_ga… -0.763  disabil… timelimited           0.763           1.23 
#> 24 b_family_values… -3.78   family_… timelimited           3.78            6.09 
#> 
#> 
```
