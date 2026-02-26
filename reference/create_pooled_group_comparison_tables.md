# Create pooled group comparison table (interaction models)

Uses pooled Apollo models with group interaction terms (d\_\*) to
compare coefficients between subgroups for both binary and multinomial
models.

## Usage

``` r
create_pooled_group_comparison_tables()
```

## Value

list of gt tables (binary and multinomial)

## Examples

``` r
tables <- baitlist::create_pooled_group_comparison_tables()
tables$binary


  











Subgroup comparison - binary pooled interaction models
```

Criteria

Amsterdam UMC vs. OLVG

Intensivists vs. Fellows

Wald statistic

Uncorrected *p* value

*p* value

Wald statistic

Uncorrected *p* value

*p* value

Overall Group Difference

14.4  

0.346

50\*\*\*

\< 0.0001

Individual Criteria

Expected additional ICU length of stay

1.69  

0.194

1

2.21  

0.137

0.822

Clinical situation

0.463  

0.496

1

3.33  

0.0682

0.478

Age (years)

0.118  

0.731

1

0.383  

0.536

1

Frailty at hospital admission

0.00898  

0.925

1

10.3\*

0.0013

0.0169

Life expectancy (pre-admission)

0.0128  

0.91

1

0.96  

0.327

1

Burden of Suffering

0.54  

0.462

1

5.49  

0.0192

0.192

Cardiovascular impairment

0.00034  

0.985

1

0.0272  

0.869

1

Pulmonary impairment

1.1  

0.295

1

4.5  

0.0338

0.304

Renal impairment

0.00321  

0.955

1

0.548  

0.459

1

Neurological impairment

0.026  

0.872

1

3.96  

0.0467

0.373

Gastro-intestinal impairment

0.415  

0.519

1

0.438  

0.508

1

Patient or Family Values

0.0586  

0.809

1

5.76  

0.0164

0.181

Constant

0.266  

0.606

1

5.92  

0.015

0.18

\* *p* \< 0.05; \*\*\* *p* \< 0.001
