# Runs linearity tests for multi-level ordered categories.

Runs linearity tests for multi-level ordered categories.

## Usage

``` r
run_linearity_tests()
```

## Value

list containing gt table ('summary_table') and combined plot
('dashboard')

## Examples

``` r
lin <- run_linearity_tests()
#> Testing linearity for: age
#> Testing linearity for: frailty
#> Testing linearity for: life_expectancy
#> Testing linearity for: disability_cardiovascular
#> Testing linearity for: disability_pulmonary
#> Testing linearity for: disability_renal
#> Testing linearity for: disability_neurological
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
lin$summary_table


  


Linearity Diagnostics for Ordered Covariates
```

Covariate

Likelihood-ratio test *(p)*¹

Quadratic term *(p)*²

AIC: linear model³

AIC: categorical model³

Preferred functional form

Age (years)

0.020

0.934

1128.3

1124.5

Non-linear

Frailty at hospital admission

0.842

0.842

1249

1251

Linear

Life expectancy (pre-admission)

\< 0.001

\< 0.001

1187.6

1173.9

Non-linear

Cardiovascular impairment

0.360

0.548

1249.1

1251

Linear

Pulmonary impairment

0.002

0.002

1245.5

1237.8

Non-linear

Renal impairment

0.012

0.013

1243.4

1239.1

Non-linear

Neurological impairment

0.819

0.819

1248.3

1250.2

Linear

¹ Likelihood-ratio test comparing linear vs. level-specific coeficients
model.

² Wald test for the quadratic (x²) term in a polynomial model.

³ Akaike Information Criterion; lower values indicate better relative
model support.
