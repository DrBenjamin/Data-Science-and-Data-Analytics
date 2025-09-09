# Data Science and Data Analytics

Course Data Science and Data Analytics in the Bachelor Studies International Business Management (B. A.) at the Hochschule Fresenius - University of Applied Sciences - International Business School in Cologne Germany.

## Setup Python Environment

Setup the Python environment using `conda`:

```bash
# Create and activate the conda environment
conda env create -f python/environment.yml
conda activate r-reticulate
```

## Setup R Environment

Setup the R environment using `renv`:

```bash
# Installing renv
Rscript -e 'install.packages("renv", repos="https://cloud.r-project.org"); renv::restore(lockfile = "r-code/renv.lock")'

# Installing reticulate package
Rscript -e 'install.packages("reticulate", repos="https://cloud.r-project.org")'

# Installing rmarkdown package
Rscript -e 'install.packages("rmarkdown", repos="https://cloud.r-project.org")'

# Installing knitr package
Rscript -e 'install.packages("knitr", repos="https://cloud.r-project.org")'

# Installing RefManageR package
Rscript -e 'install.packages("RefManageR", repos="https://cloud.r-project.org")'
```

In the R console:

```r
# Installing renv package if not already installed
install.packages('renv')

# Restoring the R environment from the lockfile
renv::restore()

# Snapshot the current state of the R environment
renv::settings$snapshot.type("all")
renv::snapshot(confirm = FALSE)

# Installing needed packages
install.packages(c("jsonlite", "rlang"))
```

Update the project's `.Rprofile`:

```txt
source("r-code/renv/activate.R")
```

and create a `.Renviron` file in the project root with the following content:

```txt
RENV_PROJECT=./r-code
```

### Update R Environment

```r
# Updating renv packages
renv::update()
```

## Knitting the Document

```bash
# Knitting the quarto document
quarto render Data_Science_and_Data_Analytics.qmd
```
