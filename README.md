# BAIT Life Sustaining Therapy (BAITLiST)

Behaviourial artificial intelligence technology (BAIT) for continuation or withdrawal of Life Sustaining Therapy (LST) 
in the Intensive Care unit

## Setup R environment

Uses the `renv` package to create a reproducible environment

``` r
# Setup a renv environment
# renv::init()

# install individual packages
# install.packages("tidyverse")
# install.packages("apollo")
# install.packages("readxl")
# install.packages("svglite")
# install.packages("ggsignif")
# install.packages("gt")
# install.packages("pkgdown")
# install.packages("katex")
# install.packages("svglite")
# install.packages("ggpattern")

# Update packages using renv
# renv::update

# Snapshot after changes
renv::snapshot()

# restore environment
renv::restore()
```

## Load development packages

Used for developing this package

``` r
# install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
library(devtools)

# Add devtools to .Rprofile
use_devtools()

# Check if correctly installed
devtools::dev_sitrep()

# Creates package
usethis::create_package("baitlist")

# Add dependencies
usethis::use_package("rlang")
usethis::use_package("dplyr")
usethis::use_package("tidyr")
usethis::use_package("stringr")
usethis::use_package("readxl")
usethis::use_package("apollo")
usethis::use_package("ggplot2")
usethis::use_package("ggsignif")
usethis::use_package("gt")
usethis::use_package("magrittr")
usethis::use_package("pkgdown")
usethis::use_package("katex")
usethis::use_package("svglite")
usethis::use_package("ggpattern")
usethis::use_package("stats")
usethis::use_package("utils")
usethis::use_package("fs")
usethis::use_package("patchwork")
usethis::use_package("tibble")

# Update documentation and NAMESPACE
devtools::document()

# Test package
devtools::test()

# Update documentation, builds and checks
devtools::check()
```

## Running analysis

Model the data and calculate feature importance across groups of respondents

``` r
# Load baitlist package
# Allows accessing functions with baitlist::fun()
devtools::load_all()

# Show linearity tests
baitlist::run_linearity_tests()

# Fit binary logit models for all groups. Disables backward elimination by setting threshold to 1
baitlist::fit_bait_binary(elimination_threshold = 1)

# Fit multinomial logit models for all groups. Disables backward elimination by setting threshold to 1
baitlist::fit_bait_multinomial(elimination_threshold = 1)

# Fit pooled interaction models
baitlist::fit_pooled_models()

# Calculate feature importance using standardized coefficients and maximum utility contribution
baitlist::feature_importance_all()

# Create tables and figures
# Tables
baitlist::create_criteria_table()
baitlist::create_model_weights_tables()
baitlist::create_pooled_group_comparison_tables()

# Figures
baitlist::plot_relative_importance()
baitlist::plot_pooled_group_comparison()
```
## Package Documentation
Documentation of this package was created using [roxygen2](https://roxygen2.r-lib.org/) 
and [pkgdown](https://pkgdown.r-lib.org/). The most recent documentation can be found [here](https://patrickthoral.github.io/baitlist/).

```
# Run once to configure your package to use and deploy pkgdown
usethis::use_pkgdown_github_pages()

# Preview your site locally before publishing
devtools::install()
pkgdown::build_site()
pkgdown::build_home_index()
pkgdown::init_site()
```
