# Create Model Weights tables

Displays the model weights, constant, Null log-likelihood and estimated
model log-likelihood and adjusted rho-squared of the different models.
Saves the table as `data/tables/model_weights_<group>.html` using the gt
package.

## Usage

``` r
create_model_weights_tables()
```

## Value

gt table of last model

## Examples

``` r
create_model_weights_tables()


  







Fellows model
```

Criteria

Weight  
(Robust SE)

*p* value

Expected additional ICU length of stay

0.169  
(0.183)

0.357

Clinical situation

1.63  
(0.679)

0.0162

Age (years)

-1.35  
(0.237)

\< 0.0001

Frailty at hospital admission

-1.42  
(0.328)

\< 0.0001

Life expectancy (pre-admission)

0.215  
( 0.2)

0.283

Burden of Suffering

-1.8  
(0.556)

0.00123

Cardiovascular impairment

-0.39  
(0.162)

0.0158

Pulmonary impairment

-1.07  
(0.215)

\< 0.0001

Renal impairment

-0.546  
(0.248)

0.0275

Neurological impairment

-1.38  
(0.542)

0.011

Gastro-intestinal impairment

-0.828  
(0.494)

0.0934

Patient or Family Values

-4.13  
(0.85)

\< 0.0001

Constant

9.33  
(1.75)

\< 0.0001

Goodness of Fit

Null log-likelihood

-173

Log-likelihood of estimated model

-114

Adjusted $$\rho^{2}$$ρ2

0.268
