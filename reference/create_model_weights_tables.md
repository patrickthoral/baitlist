# Create Model Weights tables

Displays the model weights, constant, Null log-likelihood and estimated
model log-likelihood and adjusted rho-squared of the binary and
multinomial models for each model separately and a large combined table
for across all groups of each model type. Saves the tables as
`extdata/tables/<binary|multinomial>/model_weights_<group>.html` using
the gt package.

## Usage

``` r
create_model_weights_tables()
```

## Value

list of gt tables

## Examples

``` r
tables <- baitlist::create_model_weights_tables()
#> Creating model weights tables...
#> Processing All participants model (binary)...
#> Processing Amsterdam UMC model (binary)...
#> Processing OLVG model (binary)...
#> Processing Intensivists model (binary)...
#> Processing Fellows model (binary)...
#> Creating combined table across group (binary)...
#> Processing All participants model (multinomial)...
#> Processing Amsterdam UMC model (multinomial)...
#> Processing OLVG model (multinomial)...
#> Processing Intensivists model (multinomial)...
#> Processing Fellows model (multinomial)...
#> Creating combined table across group (multinomial)...
#> Done.
tables$binary$aggregate


  







All participants model
```

Criteria

Weight  
\[95% CI\]

*p* value

Expected additional ICU length of stay

-0.0826  
\[-0.353, 0.188\]

0.549

Clinical situation

0.582  
\[0.057, 1.107\]

0.0297

Age (years)

-1.19  
\[-1.432, -0.950\]

\< 0.0001

Frailty at hospital admission

-0.496  
\[-0.807, -0.185\]

0.00177

Life expectancy (pre-admission)

0.364  
\[0.147, 0.581\]

0.00102

Burden of Suffering

-0.614  
\[-1.228, -0.001\]

0.0496

Cardiovascular impairment

-0.385  
\[-0.532, -0.239\]

\< 0.0001

Pulmonary impairment

-0.618  
\[-0.894, -0.343\]

\< 0.0001

Renal impairment

-0.347  
\[-0.643, -0.050\]

0.0219

Neurological impairment

-0.451  
\[-0.895, -0.006\]

0.0468

Gastro-intestinal impairment

-0.503  
\[-0.866, -0.139\]

0.0067

Patient or Family Values

-2.41  
\[-3.039, -1.788\]

\< 0.0001

Constant

5.33  
\[3.467, 7.200\]

\< 0.0001

Goodness of Fit

Null log-likelihood

-624

Log-likelihood of estimated model

-456

Adjusted $$\rho^{2}$$ρ2

0.249
