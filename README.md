# BAIT Life Sustaining Therapy (BAITLiST)
Behaviourial artificial intelligence technology (BAIT) for continuation or withdrawal of 
Life Sustaining Therapy (LST) in the Intensive Care unit


## Setup R environment
Uses the `renv` package to create a reproducible environment
```r
# Setup a renv environment
renv::init()

# install individual packages
# install.packages("tidyverse")
# install.packages("apollo")
# install.packages("readxl")
# install.packages("svglite") 

# Snapshot after changes
# renv::snapshot()

# restore environment
renv::restore()

```

## Load development packages
Used for developing this package
```r
# install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
library(devtools)

# Add devtools to .Rprofile
use_devtools()

# Check if correctly installed
devtools::dev_sitrep()

# Creates package
usethis::create_package("baitlist")

# Add dependencies
usethis::use_package("dplyr")
usethis::use_package("tidyr")
usethis::use_package("readxl")
usethis::use_package("apollo")
usethis::use_package("ggplot2")

# Update documentation
devtools::document()

```

## Running analysis
Model the data and calculate feature importance across groups of respondents
```r
# Load baitlist package
# Allows accessing functions with baitlist::fun()
devtools::load_all()

# Fit binary logit models for all groups. Disables backward elimination by setting threshold to 1
baitlist::fit_bait_binary(elimination_threshold = 1)

# Fit multinomial logit models for all groups. Disables backward elimination by setting threshold to 1
baitlist::fit_bait_multinomial(elimination_threshold = 1)

# Calculate feature importance using standardized coefficients
baitlist::standardized_coefficients()

# Calculate feature importance using maximum utility contribution
baitlist::maximum_utility_contribution()

# Compare model weights between models using Wald test
baitlist::compare_models()

# Create tables and figures
baitlist::criteria_table()
baitlist::plot_relative_importance()

```

