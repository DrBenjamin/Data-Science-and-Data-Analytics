# Setting renv configuration options BEFORE activating renv so they are
# respected by the activation script.
# Setting/Enabling pak support and locking behavior as requested.
options(
  "renv.config.pak.enabled" = TRUE,
  "renv.config.locking.enabled" = TRUE
)

## Ensure renv uses the project root (`.`) as the project while allowing the
## lockfile to remain in `r-code/renv.lock` if present. We set the environment
## variables before activating renv so the activation script respects them.
rcode_lock <- file.path("/Users/ben/Documents/Studies/Business Administration (M. A.)/Analytical Skills for Business/Projects/Analytical-Skills-for-Business/renv.lock")
if (file.exists(rcode_lock)) {
  # If not already set via .Renviron, set RENV_PROJECT to the project root and
  # point RENV_PATHS_LOCKFILE to the lockfile inside project root.
  if (!nzchar(Sys.getenv("RENV_PROJECT"))) Sys.setenv(RENV_PROJECT = normalizePath("/Users/ben/Documents/Studies/Business Administration (M. A.)/Analytical Skills for Business/Projects/Analytical-Skills-for-Business"))
  if (!nzchar(Sys.getenv("RENV_PATHS_LOCKFILE"))) Sys.setenv(RENV_PATHS_LOCKFILE = normalizePath(rcode_lock))
  message("RENV_PROJECT set to project root; RENV_PATHS_LOCKFILE set to renv.lock (lockfile detected)")
}

## Activate renv from the project root so project-local libraries are used.
if (file.exists("/Users/ben/Documents/Studies/Business Administration (M. A.)/Analytical Skills for Business/Projects/Analytical-Skills-for-Business/renv/activate.R")) {
  tryCatch({
    # source the activation script quietly; it is idempotent
    source("/Users/ben/Documents/Studies/Business Administration (M. A.)/Analytical Skills for Business/Projects/Analytical-Skills-for-Business/renv/activate.R")
  }, error = function(e) message("Failed to source activate.R: ", e$message))
} else {
  # fallback: attempt to activate via the renv package (if installed)
  if (requireNamespace("renv", quietly = TRUE)) {
    tryCatch(renv::activate(), error = function(e) message("renv::activate() failed: ", e$message))
  }
}
# Project .Rprofile
# Keeping this minimal: session watcher should be started from the *user* ~/.Rprofile.
# This file exists to avoid accidental overrides and can host project-specific options.

# Adding project-specific options (example):
# options(stringsAsFactors = FALSE)

# Adding a lightweight check to inform if user-level watcher not active
if (interactive() && Sys.getenv("RSTUDIO") == "" && Sys.getenv("TERM_PROGRAM") == "vscode") {
  if (!any(grepl("tools:vscode", search(), fixed = TRUE))) {
    user_init <- file.path(Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"), ".vscode-R", "init.R")
    if (file.exists(user_init)) {
      message("(Project .Rprofile) Attempting to source user VS Code watcher init file...")
      try(local(source(user_init, chdir = TRUE, local = TRUE)), silent = TRUE)
      if (!any(grepl("tools:vscode", search(), fixed = TRUE))) {
        message("(Project .Rprofile) Sourcing did not attach tools:vscode. Check required packages (jsonlite, rlang) and extension path.")
      }
    } else {
      message("(Project .Rprofile) VS Code session watcher not yet attached and user init missing: ", user_init)
    }
  }
}

# --- Begin radian configuration (appended) ---
if (interactive()) {
  # Only proceed if we're inside radian (it sets RADIAN_VERSION). Sys.getenv always returns a string; use != "" rather than NULL tests.
  if (nzchar(Sys.getenv("RADIAN_VERSION"))) {
    current_opts <- options()

    safe_set <- function(name, value) {
      if (is.null(current_opts[[name]])) {
        options(structure(list(value), names = name))
      }
    }

    # Core requested feature: automatic bracket/quote matching
    safe_set("radian.auto_match", TRUE)

    # Additional quality-of-life defaults (comment out any you don't want)
    safe_set("radian.insert_new_line", TRUE)
    safe_set("radian.color_scheme", "native")
    safe_set("radian.highlight_matching_bracket", TRUE)

    # Console friendliness / nicer printing
    safe_set("tibble.print_min", 6)
    safe_set("tibble.width", Inf)
    if (getOption("scipen", 0) < 6) options(scipen = 6)

    # reticulate: prefer project conda env python if not already pinned
    # Sys.getenv returns "" if unset, so test with nzchar()
    if (!nzchar(Sys.getenv("RETICULATE_PYTHON"))) {
      py_bin <- file.path(Sys.getenv("HOME"), "conda/envs/r-reticulate/bin/python")
      if (file.exists(py_bin)) Sys.setenv(RETICULATE_PYTHON = py_bin)
    }

    rm(safe_set, current_opts)
  }
}
# --- End radian configuration ---

# Setting project working directory to project root for interactive sessions.
if (interactive()) {
  target <- file.path(getwd(), "./")
  if (dir.exists(target)) {
    setwd(target)
  }
}
