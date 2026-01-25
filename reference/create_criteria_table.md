# Create Criteria table

Displays the criteria and associated levels used in the discrete choice
experiment. Saves the pivot table as `data/tables/table_criteria.csv`.

## Usage

``` r
create_criteria_table()
```

## Value

Tibble containing criteria

## Examples

``` r
create_criteria_table()
#> # A tibble: 12 × 5
#>    Criterion                             `Level 1` `Level 2` `Level 3` `Level 4`
#>    <chr>                                 <chr>     <chr>     <chr>     <chr>    
#>  1 Expected additional ICU length of st… A couple… A couple… NA        NA       
#>  2 Clinical situation                    Deterior… No impro… NA        NA       
#>  3 Age (years)                           40        55        70        85       
#>  4 Frailty at hospital admission         1 - 2     3 - 4     5 - 6     NA       
#>  5 Life expectancy (pre-admission)       6 - 12 m… 1 - 5 ye… > 5 years NA       
#>  6 Burden of Suffering                   Limited   Severe    NA        NA       
#>  7 Cardiovascular impairment             NYHA I    NYHA II   NYHA III  NYHA IV  
#>  8 Pulmonary impairment                  No impai… Moderate… Severe i… NA       
#>  9 Renal impairment                      No impai… Pre-dial… Dialysis… NA       
#> 10 Neurological impairment               mRS 0-1   mRS 2-3   mRS 4-5   NA       
#> 11 Gastro-intestinal impairment          Without … Tube-fee… NA        NA       
#> 12 Patient or Family Values              Expected… Expected… NA        NA       
```
