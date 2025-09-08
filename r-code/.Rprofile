source("renv/activate.R")
# Setting: when an interactive session starts inside r-code, activate renv from the project root
# and keep r-code as the working directory.

try({
  # project root is parent of r-code
  rcode_path <- normalizePath(".")
  proj_root <- normalizePath(file.path(rcode_path, ".."))

  if (interactive()) {
    # activate renv from project root if possible
    renv_activate <- file.path(proj_root, "renv", "activate.R")
    if (file.exists(renv_activate)) {
      tryCatch(source(renv_activate), error = function(e) {
        message("renv activate failed: ", e$message)
      })
    } else if (requireNamespace("renv", quietly = TRUE)) {
      tryCatch(renv::activate(project = proj_root), error = function(e) {
        message("renv::activate() failed: ", e$message)
      })
    }

    # ensure working directory remains r-code
    if (dir.exists(rcode_path)) {
      setwd(rcode_path)
      message("Working directory set to: ", getwd())
    }
  }
})
