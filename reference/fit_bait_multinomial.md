# Fits the responses in a BAIT multinomial logistic regression model for each respondent group

Uses the `apollo` package for modelling.

## Usage

``` r
fit_bait_multinomial(elimination_threshold = 0.2)
```

## Arguments

- elimination_threshold:

  Performs step-wise backward elimination of least significant
  coefficients using p \> `elimination_threshold`. Default: 0.20. To
  disable backward elimination of coefficients set elimination_threshold
  = 1

## Examples

``` r
baitlist::fit_bait_multinomial(elimination_threshold = 1)
```
