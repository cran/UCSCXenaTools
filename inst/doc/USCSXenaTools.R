## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("UCSCXenaTools")

## ----gh-installation, eval = FALSE---------------------------------------
#  # install.packages("remotes")
#  remotes::install_github("ropensci/UCSCXenaTools")

## ---- eval=FALSE---------------------------------------------------------
#  remotes::install_github("ropensci/UCSCXenaTools", build_vignettes = TRUE, dependencies = TRUE)

## ------------------------------------------------------------------------
library(UCSCXenaTools)
data(XenaData)

head(XenaData)

## ------------------------------------------------------------------------
# The options in XenaFilter function support Regular Expression
XenaGenerate(subset = XenaHostNames=="tcgaHub") %>% 
  XenaFilter(filterDatasets = "clinical") %>% 
  XenaFilter(filterDatasets = "LUAD|LUSC|LUNG") -> df_todo

df_todo

## ------------------------------------------------------------------------
x1 = XenaScan(pattern = 'Blood')
x2 = XenaScan(pattern = 'LUNG', ignore.case = FALSE)

x1 %>%
    XenaGenerate()
x2 %>%
    XenaGenerate()

## ------------------------------------------------------------------------
XenaQuery(df_todo) %>%
  XenaDownload() -> xe_download

## ------------------------------------------------------------------------
cli = XenaPrepare(xe_download)
class(cli)
names(cli)

## ------------------------------------------------------------------------
XenaGenerate(subset = XenaHostNames=="tcgaHub") %>%
    XenaFilter(filterDatasets = "clinical") %>%
    XenaFilter(filterDatasets = "LUAD") -> to_browse

to_browse

XenaGenerate(subset = XenaHostNames=="tcgaHub") %>%
    XenaFilter(filterDatasets = "clinical") %>%
    XenaFilter(filterDatasets = "LUAD|LUSC") -> to_browse2

to_browse2

## ----eval=FALSE----------------------------------------------------------
#  # This will open you web browser
#  XenaBrowse(to_browse)
#  
#  XenaBrowse(to_browse, type = "cohort")

## ---- error=TRUE---------------------------------------------------------
# This will throw error
XenaBrowse(to_browse2)

XenaBrowse(to_browse2, type = "cohort")

## ---- eval=FALSE---------------------------------------------------------
#  XenaBrowse(to_browse2, multiple = TRUE)
#  XenaBrowse(to_browse2, type = "cohort", multiple = TRUE)

