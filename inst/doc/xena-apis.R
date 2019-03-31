## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----include=FALSE-------------------------------------------------------
#devtools::load_all("~/Repo/UCSCXenaTools/")
library(UCSCXenaTools)
all_vs = ls(envir = as.environment("package:UCSCXenaTools"),
            all.names = TRUE)

## ----echo=FALSE----------------------------------------------------------
grep("^\\.p", all_vs, value = TRUE)

## ---- echo=F-------------------------------------------------------------
funs_low_in = c(
    '.host_cohorts',
    '.cohort_datasets',
    '.cohort_datasets_count',
    '.cohort_samples_each',
    '.cohort_samples_any',
    '.cohort_samples_all',
    '.dataset_samples_each',
    '.dataset_samples_any',
    '.dataset_samples_all'
)
funs_low_in

## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------
#devtools::load_all("~/Repo/UCSCXenaTools/")
library(dplyr)
library(UCSCXenaTools)
load(system.file("api.RData", package = "UCSCXenaTools"))
api_df = arrange(api_df, Level)
knitr::kable(api_df, caption = "API functions in UCSCXenaTools")

## ----echo=FALSE----------------------------------------------------------
    grep("^\\.xq", all_vs, value = TRUE)

## ------------------------------------------------------------------------
.xq_all_cohorts

## ------------------------------------------------------------------------
cat(.xq_all_cohorts)

