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
usethis::use_package("readxl")
usethis::use_package("apollo")

# Update documentation
devtools::document()
```

## Running analysis
Model the data and calculate feature importance across groups of respondents
```r
# Load baitlist package
# Allows accessing functions with baitlist::fun()
devtools::load_all()

# Fit binary logit models for all groups
baitlist::fit_bait_binary()

# Calculate feature importance
baitlist::feature_importance_binary()
```

