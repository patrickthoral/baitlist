# Create group comparison table

Creates table comparing coefficients weights with both groups using the
Wald test. Saves the table as `data/tables/table_group_comparison.html`.

## Usage

``` r
create_group_comparison_table()
```

## Value

gt table

## Examples

``` r
create_group_comparison_table()


  









Subgroup comparison
```

Criteria

Amsterdam UMC vs. OLVG

Intensivists vs. Fellows

Wald statistic

*p* value

Wald statistic

*p* value

Expected additional ICU length of stay

1.64

0.201

2.11

0.146

Clinical situation

0.45

0.503

3.11

0.0777

Age (years)

0.115

0.735

0.361

0.548

Frailty at hospital admission

0.00872

0.926

9.72\*\*

0.00182

Life expectancy (pre-admission)

0.0125

0.911

0.909

0.34

Burden of Suffering

0.524

0.469

5.18\*

0.0229

Cardiovascular impairment

0.000326

0.986

0.0256

0.873

Pulmonary impairment

1.07

0.302

4.28\*

0.0386

Renal impairment

0.00312

0.955

0.519

0.471

Neurological impairment

0.0253

0.874

3.71

0.0541

Gastro-intestinal impairment

0.403

0.525

0.41

0.522

Patient or Family Values

0.0568

0.812

5.38\*

0.0204

Constant

0.258

0.612

5.58\*

0.0181

\* *p* \< 0.05; \*\* *p* \< 0.01
