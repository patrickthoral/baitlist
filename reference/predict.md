# Predict choice based on patient characteristics and family values

Use the `apollo` package to predict the choice based on the fitted
models

## Usage

``` r
predict(
  expected_los = 0,
  clinical_situation = 0,
  age = 0,
  frailty = 0,
  life_expectancy = 0,
  suffering = 0,
  disability_cardiovascular = 0,
  disability_pulmonary = 0,
  disability_renal = 0,
  disability_neurological = 0,
  disability_gastrointestinal = 0,
  family_values = 0,
  type = "binary",
  group = "aggregate"
)
```

## Arguments

- expected_los:

  Expected additional ICU length of stay. Use one of the following
  (Default = 0):

  |       |                    |
  |-------|--------------------|
  | Value | Description        |
  | 0     | A couple of weeks  |
  | 1     | A couple of months |

- clinical_situation:

  Clinical Situation. Use one of the following (Default = 0):

  |       |                |
  |-------|----------------|
  | Value | Description    |
  | 0     | Deterioration  |
  | 1     | No improvement |

- age:

  Age. Use one of the following (Default = 0):

  |       |             |
  |-------|-------------|
  | Value | Description |
  | 0     | 40 years    |
  | 1     | 55 years    |
  | 2     | 70 years    |
  | 3     | 85 years    |

- frailty:

  Frailty at hospital admission. Use one of the following (Default = 0):

  |       |                             |
  |-------|-----------------------------|
  | Value | Description                 |
  | 0     | Clinical Frailty Score: 1-2 |
  | 1     | Clinical Frailty Score: 3-4 |
  | 2     | Clinical Frailty Score: 5-6 |

- life_expectancy:

  Life expectancy (pre-admission). Use one of the following (Default =
  0):

  |       |               |
  |-------|---------------|
  | Value | Description   |
  | 0     | 6 - 12 months |
  | 1     | 1 - 5 years   |
  | 1     | \> 5 years    |

- suffering:

  Burden of Suffering. Use one of the following (Default = 0):

  |       |             |
  |-------|-------------|
  | Value | Description |
  | 0     | Limited     |
  | 1     | Severe      |

- disability_cardiovascular:

  Expected cardiovascular impairment after discharge. Use one of the
  following (Default = 0):

  |       |             |
  |-------|-------------|
  | Value | Description |
  | 0     | NYHA I      |
  | 1     | NYHA II     |
  | 2     | NYHA III    |
  | 3     | NYHA IV     |

- disability_pulmonary:

  Expected pulmonary impairment after discharge. Use one of the
  following (Default = 0):

  |       |                     |
  |-------|---------------------|
  | Value | Description         |
  | 0     | No impairment       |
  | 1     | Moderate impairment |
  | 2     | Severe impairment   |

- disability_renal:

  Expected renal impairment after discharge. Use one of the following
  (Default = 0):

  |       |                                |
  |-------|--------------------------------|
  | Value | Description                    |
  | 0     | No impairment (GFR \> 30)      |
  | 1     | Pre-dialysis (GFR 15-30)       |
  | 2     | Dialysis dependent (GFR \< 15) |

- disability_neurological:

  Expected neurological impairment after discharge. Use one of the
  following (Default = 0):

  |       |             |
  |-------|-------------|
  | Value | Description |
  | 0     | mRS 0-1     |
  | 1     | mRS 2-3     |
  | 2     | mRS 4-5     |

- disability_gastrointestinal:

  Expected gastrointestinal impairment after discharge. Use one of the
  following (Default = 0):

  |       |                        |
  |-------|------------------------|
  | Value | Description            |
  | 0     | Without tube-feeding   |
  | 1     | Tube-feeding dependent |

- family_values:

  Patient or Family Values. Use one of the following (Default = 0):

  |       |                                                                    |
  |-------|--------------------------------------------------------------------|
  | Value | Description                                                        |
  | 0     | Expected future physical disabilities are possibly acceptable      |
  | 1     | Expected future physical disabilities are most likely unacceptable |

- type:

  Either "binary" or "multinomial". Default: "binary".

- group:

  Either "aggregate", "aumc", "olvg", "intensivists" or "fellows".
  Default: "aggregate"

## Value

Returns tibble containing the prediction.

## Examples

``` r
predict(family_values = 1)
#>    withdraw  continue
#> 1 0.0525804 0.9474196
predict(type = "multinomial", expected_los = 1, clinical_situation = 1, age = 1, frailty = 1, life_expectancy = 1, suffering = 1, disability_cardiovascular = 1, disability_pulmonary = 1, disability_renal = 1, disability_neurological = 1, disability_gastrointestinal = 1, family_values = 1)
#>    withdraw timelimited   continue
#> 1 0.6023636   0.3193513 0.07828503
```
