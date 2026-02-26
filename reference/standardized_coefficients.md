# Calculate feature importance using standardized coefficients

Calculates feature importance of the BAIT models using standardized
coefficients (\\\beta ^{\ast }={\frac {s\_{x}}{s\_{y}}}\beta\\) as
percentage of total. Feature importance is saved for each model as csv
files in the `data` folder.

## Usage

``` r
standardized_coefficients(modeltype = "binary", group = "aggregate")
```

## Arguments

- modeltype:

  Model type. Either 'binary' or 'multinomial'

- group:

  Participant group. One of the following 'aggregate', 'aumc', 'olvg',
  'intensivists', 'fellows'

## Examples

``` r
baitlist::standardized_coefficients()
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
```
