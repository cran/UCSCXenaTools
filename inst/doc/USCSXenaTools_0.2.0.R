## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----gh-installation, eval = FALSE---------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("ShixiangWang/UCSCXenaTools", build_vignettes = TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  browseVignettes("UCSCXenaTools")

## ------------------------------------------------------------------------
library(UCSCXenaTools)
data(XenaData)

head(XenaData)

## ------------------------------------------------------------------------
XenaGenerate()

## ------------------------------------------------------------------------
XenaGenerate(subset = XenaHostNames=="TCGA")

## ------------------------------------------------------------------------
xe = XenaGenerate(subset = XenaHostNames=="TCGA")
# get hosts
hosts(xe)
# get cohorts
head(cohorts(xe))
# get datasets
head(datasets(xe))

## ------------------------------------------------------------------------
(XenaFilter(xe, filterDatasets = "clinical") -> xe2)

## ------------------------------------------------------------------------
XenaFilter(xe2, filterDatasets = "LUAD|LUSC|LUNG") -> xe2

## ------------------------------------------------------------------------
xe2_query = XenaQuery(xe2)
xe2_query

## ------------------------------------------------------------------------
xe2_download = XenaDownload(xe2_query)
## not run
#xe2_download = XenaDownload(xe2_query, destdir = "E:/Github/XenaData/test/")

## ------------------------------------------------------------------------
# way4: xenadownload object
cli4 = XenaPrepare(xe2_download)
names(cli4)

## ------------------------------------------------------------------------
sessionInfo()

