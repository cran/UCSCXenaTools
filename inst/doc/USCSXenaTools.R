## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("UCSCXenaTools")

## ----gh-installation, eval = FALSE---------------------------------------
#  # install.packages("remotes")
#  remotes::install_github("ShixiangWang/UCSCXenaTools", build_vignettes = TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  browseVignettes("UCSCXenaTools")
#  # or
#  ??UCSCXenaTools

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

## ---- message=FALSE------------------------------------------------------
library(dplyr)
XenaData %>% 
    filter(XenaHostNames == "TCGA", grepl("BRCA", XenaCohorts), grepl("Path", XenaDatasets)) %>%
    XenaGenerate()

## ------------------------------------------------------------------------
(XenaFilter(xe, filterDatasets = "clinical") -> xe2)

## ------------------------------------------------------------------------
XenaFilter(xe2, filterDatasets = "LUAD|LUSC|LUNG") -> xe2

## ------------------------------------------------------------------------
xe %>% 
    XenaFilter(filterDatasets = "clinical") %>% 
    XenaFilter(filterDatasets = "luad|lusc|lung")

## ------------------------------------------------------------------------
XenaGenerate(subset = XenaHostNames=="TCGA") %>%
    XenaFilter(filterDatasets = "clinical") %>%
    XenaFilter(filterDatasets = "LUAD") -> to_browse

to_browse

XenaGenerate(subset = XenaHostNames=="TCGA") %>%
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

## ------------------------------------------------------------------------
xe2_query = XenaQuery(xe2)
xe2_query

## ------------------------------------------------------------------------
xe2_download = XenaDownload(xe2_query)

## ------------------------------------------------------------------------
# way4: xenadownload object
cli4 = XenaPrepare(xe2_download)
names(cli4)

## ------------------------------------------------------------------------
args(getTCGAdata)

# or run
# ??getTCGAdata to read documentation

## ------------------------------------------------------------------------
getTCGAdata(c("UVM", "LUAD"))

tcga_data = getTCGAdata(c("UVM", "LUAD"))

# only return XenaHub object
tcga_data$Xena

# only return datasets information
tcga_data$DataInfo

## ---- eval=FALSE---------------------------------------------------------
#  # only download clinical data
#  getTCGAdata(c("UVM", "LUAD"), download = TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  # download RNASeq data (use UVM as an example)
#  downloadTCGA(project = "UVM",
#                   data_type = "Gene Expression RNASeq",
#                    file_type = "IlluminaHiSeq RNASeqV2")

## ------------------------------------------------------------------------
args(downloadTCGA)

## ------------------------------------------------------------------------
availTCGA()

## ---- eval=FALSE---------------------------------------------------------
#  View(showTCGA())

## ---- eval=FALSE---------------------------------------------------------
#  UCSCXenaTools::XenaShiny()

## ------------------------------------------------------------------------
sessionInfo()

