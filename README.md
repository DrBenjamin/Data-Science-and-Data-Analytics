# Data Science and Data Analytics

Course Data Science and Data Analytics in the Bachelor Studies International Business Management (B. A.) at the Hochschule Fresenius - University of Applied Sciences - International Business School in Cologne Germany.

## Setup R Environment

```r
# Installing renv package if not already installed
install.packages('renv')

# Restoring the R environment from the lockfile
renv::restore()

# Installing needed packages
install.packages(c("jsonlite", "rlang"))
```

Update the project's R.profile:

```txt
source("r-code/renv/activate.R")
```

### Update R Environment

```r
# Updating renv packages
renv::update()

# Updating renv lockfile
renv::snapshot(lockfile = "r-code/renv.lock")

## Knitting the Document

```bash
# Knitting the quarto document
quarto render Data_Science_and_Data_Analytics.qmd
```
