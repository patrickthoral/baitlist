# Load responses Reads data from the data/responses.xlsx file for specific groups or all if not specified.

Load responses Reads data from the data/responses.xlsx file for specific
groups or all if not specified.

## Usage

``` r
load_responses(group = "aggregate")
```

## Arguments

- group:

  The group to filter the data on. Valid values: 'aumc', 'olvg',
  'intensivists', 'fellows'. If omitted all responses are returned.

## Value

data.frame (tibble) containing responses for the specified group

## Examples

``` r
data_fellows <- load_responses('fellows')
```
