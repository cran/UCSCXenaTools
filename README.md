
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<table class="table">

<thead>

<tr class="header">

<th align="left">

Usage

</th>

<th align="left">

Release

</th>

<th align="left">

Development

</th>

</tr>

</thead>

<tbody>

<tr class="odd">

<td align="left">

<a href="https://www.gnu.org/licenses/gpl-3.0.en.html"><img src="https://img.shields.io/badge/licence-GPL--3-blue.svg" alt="Licence"></a>

</td>

<td align="left">

<a href="https://cran.r-project.org/package=UCSCXenaTools"><img src="https://www.r-pkg.org/badges/version/UCSCXenaTools" alt="CRAN"></a>

</td>

<td align="left">

<a href="https://travis-ci.org/ShixiangWang/UCSCXenaTools"><img src="https://travis-ci.org/ShixiangWang/UCSCXenaTools.svg?branch=master" alt="Travis"></a>

</td>

</tr>

<tr class="even">

<td align="left">

<a href="https://cran.r-project.org/"><img src="https://img.shields.io/badge/R%3E%3D-3.0.0-blue.svg" alt="minimal R version"></a>

</td>

<td align="left">

<a href="https://cran.r-project.org/web/checks/check_results_UCSCXenaTools.html"><img src="https://cranchecks.info/badges/summary/UCSCXenaTools" alt="cran-checks"></a>

</td>

<td align="left">

<a href="https://ci.appveyor.com/project/ShixiangWang/UCSCXenaTools"><img src="https://ci.appveyor.com/api/projects/status/github/ShixiangWang/UCSCXenaTools?branch=master&svg=true" alt="AppVeyor"></a>

</td>

</tr>

<tr class="odd">

<td align="left">

<a href="https://CRAN.R-project.org/package=UCSCXenaTools"><img src="https://tinyverse.netlify.com/badge/UCSCXenaTools"></a>

</td>

<td align="left">

<a href="https://github.com/ropensci/onboarding/issues/315"><img src="https://badges.ropensci.org/315_status.svg" alt="rOpenSci"></a>

</td>

<td align="left">

<a href="https://codecov.io/github/ShixiangWang/UCSCXenaTools?branch=master"><img src="https://codecov.io/github/ShixiangWang/UCSCXenaTools/coverage.svg?branch=master" alt="Codecov"></a>

</td>

</tr>

<tr class="even">

<td align="left">

<a href="https://CRAN.R-project.org/package=UCSCXenaTools"><img src="http://cranlogs.r-pkg.org/badges/grand-total/UCSCXenaTools" alt="downloads"></a>

</td>

<td align="left">

</td>

<td align="left">

[![Closed
issues](https://img.shields.io/github/issues-closed/ShixiangWang/UCSCXenaTools.svg)](https://github.com/ShixiangWang/UCSCXenaTools/issues?q=is%3Aissue+is%3Aclosed)

</td>

</tr>

<tr class="odd">

<td align="left">

[![Say
Thanks\!](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/ShixiangWang)

</td>

<td align="left">

</td>

<td align="left">

<a href="https://www.repostatus.org/#active"><img src="https://www.repostatus.org/badges/latest/active.svg" alt="Project Status: Active – The project has reached a stable, usable state and is being actively developed." /></a>

</td>

</tr>

</tbody>

</table>

<br>
<!-- badges: end -->

# UCSCXenaTools <img src='man/figures/logo.png' align="right" height="200" alt="logo"/>

**UCSCXenaTools** is an R package for accessing genomics data from UCSC
Xena platform, from cancer multi-omics to single-cell RNA-seq. Public
omics data from UCSC Xena are supported through [**multiple turn-key
Xena Hubs**](https://xenabrowser.net/datapages/), which are a collection
of UCSC-hosted public databases such as TCGA, ICGC, TARGET, GTEx, CCLE,
and others. Databases are normalized so they can be combined, linked,
filtered, explored and downloaded.

## Table of Contents

  - [Installation](#installation)
  - [Data Hub List](#data-hub-list)
  - [Usage](#usage)
  - [Documentation](#documentation)
  - [APIs](#apis)
  - [Citation](#citation)
  - [Acknowledgement](#acknowledgement)

## Installation

Install stable release from CRAN with:

``` r
install.packages("UCSCXenaTools")
```

You can also install devel version of **UCSCXenaTools** from github
with:

``` r
# install.packages("remotes")
remotes::install_github("ShixiangWang/UCSCXenaTools", build_vignettes = TRUE)
```

## Data Hub List

All datasets are available at <https://xenabrowser.net/datapages/>.

Currently, **UCSCXenaTools** supports 10 data hubs of UCSC Xena.

  - UCSC Public Hub: <https://ucscpublic.xenahubs.net>
  - TCGA Hub: <https://tcga.xenahubs.net>
  - GDC Xena Hub: <https://gdc.xenahubs.net>
  - ICGC Xena Hub: <https://icgc.xenahubs.net>
  - Pan-Cancer Atlas Hub: <https://pancanatlas.xenahubs.net>
  - GA4GH (TOIL) Hub: <https://toil.xenahubs.net>
  - Treehouse Hub: <https://xena.treehouse.gi.ucsc.edu>
  - PCAWG Hub: <https://pcawg.xenahubs.net>
  - ATAC-seq Hub: <https://atacseq.xenahubs.net>
  - Singel Cell Xena hub: <https://singlecell.xenahubs.net>

If any url of data hub is changed or a new data hub is online, please
remind me by emailing to <w_shixiang@163.com> or [opening an issue on
GitHub](https://github.com/ShixiangWang/UCSCXenaTools/issues).

## Usage

Download UCSC Xena datasets and load them into R by **UCSCXenaTools** is
a workflow with `generate`, `filter`, `query`, `download` and `prepare`
5 steps, which are implemented as `XenaGenerate`, `XenaFilter`,
`XenaQuery`, `XenaDownload` and `XenaPrepare` functions, respectively.
They are very clear and easy to use and combine with other packages like
`dplyr`.

To show the basic usage of **UCSCXenaTools**, we will download clinical
data of LUNG, LUAD, LUSC from TCGA (hg19 version) data hub.

### XenaData data.frame

**UCSCXenaTools** uses a `data.frame` object (built in package)
`XenaData` to generate an instance of `XenaHub` class, which records
information of all datasets of UCSC Xena Data Hubs.

You can load `XenaData` after loading `UCSCXenaTools` into R.

``` r
library(UCSCXenaTools)
#> =========================================================================
#> UCSCXenaTools version 1.2.2
#> Github page: https://github.com/ShixiangWang/UCSCXenaTools
#> Documentation: https://shixiangwang.github.io/UCSCXenaTools/
#> 
#> If you use it in published research, please cite:
#> Wang, Shixiang, et al. "The predictive power of tumor mutational burden
#>     in lung cancer immunotherapy response is influenced by patients' sex."
#>     International journal of cancer (2019).
#> =========================================================================
#> 
data(XenaData)

head(XenaData)
#> # A tibble: 6 x 17
#>   XenaHosts XenaHostNames XenaCohorts XenaDatasets SampleCount DataSubtype
#>   <chr>     <chr>         <chr>       <chr>        <chr>       <chr>      
#> 1 https://… publicHub     Acute lymp… mullighan20… 30          copy number
#> 2 https://… publicHub     Acute lymp… mullighan20… 159         phenotype  
#> 3 https://… publicHub     Acute lymp… mullighan20… 129         copy number
#> 4 https://… publicHub     Breast Can… Caldas2007/… 242         phenotype  
#> 5 https://… publicHub     Breast Can… Caldas2007/… 220         copy number
#> 6 https://… publicHub     Breast Can… Caldas2007/… 135         gene expre…
#> # … with 11 more variables: Label <chr>, Type <chr>,
#> #   AnatomicalOrigin <chr>, SampleType <chr>, Tags <chr>, ProbeMap <chr>,
#> #   LongTitle <chr>, Citation <chr>, Version <chr>, Unit <chr>,
#> #   Platform <chr>
```

### Workflow

Select datasets.

``` r
# The options in XenaFilter function support Regular Expression
XenaGenerate(subset = XenaHostNames=="tcgaHub") %>% 
  XenaFilter(filterDatasets = "clinical") %>% 
  XenaFilter(filterDatasets = "LUAD|LUSC|LUNG") -> df_todo

df_todo
#> class: XenaHub 
#> hosts():
#>   https://tcga.xenahubs.net
#> cohorts() (3 total):
#>   TCGA Lung Adenocarcinoma (LUAD)
#>   TCGA Lung Cancer (LUNG)
#>   TCGA Lung Squamous Cell Carcinoma (LUSC)
#> datasets() (3 total):
#>   TCGA.LUAD.sampleMap/LUAD_clinicalMatrix
#>   TCGA.LUNG.sampleMap/LUNG_clinicalMatrix
#>   TCGA.LUSC.sampleMap/LUSC_clinicalMatrix
```

Query and download.

``` r
XenaQuery(df_todo) %>%
  XenaDownload() -> xe_download
#> This will check url status, please be patient.
#> All downloaded files will under directory /var/folders/mx/rfkl27z90c96wbmn3_kjk8c80000gn/T//RtmpXgPMOw.
#> The 'trans_slash' option is FALSE, keep same directory structure as Xena.
#> Creating directories for datasets...
#> Downloading TCGA.LUAD.sampleMap/LUAD_clinicalMatrix.gz
#> Downloading TCGA.LUNG.sampleMap/LUNG_clinicalMatrix.gz
#> Downloading TCGA.LUSC.sampleMap/LUSC_clinicalMatrix.gz
```

Prepare data into R for analysis.

``` r
cli = XenaPrepare(xe_download)
class(cli)
#> [1] "list"
names(cli)
#> [1] "LUAD_clinicalMatrix.gz" "LUNG_clinicalMatrix.gz"
#> [3] "LUSC_clinicalMatrix.gz"
```

### Browse datasets

Create two XenaHub objects:

  - `to_browse` - a XenaHub object containing a cohort and a dataset.
  - `to_browse2` - a XenaHub object containing 2 cohorts and 2 datasets.

<!-- end list -->

``` r
XenaGenerate(subset = XenaHostNames=="tcgaHub") %>%
    XenaFilter(filterDatasets = "clinical") %>%
    XenaFilter(filterDatasets = "LUAD") -> to_browse

to_browse
#> class: XenaHub 
#> hosts():
#>   https://tcga.xenahubs.net
#> cohorts() (1 total):
#>   TCGA Lung Adenocarcinoma (LUAD)
#> datasets() (1 total):
#>   TCGA.LUAD.sampleMap/LUAD_clinicalMatrix

XenaGenerate(subset = XenaHostNames=="tcgaHub") %>%
    XenaFilter(filterDatasets = "clinical") %>%
    XenaFilter(filterDatasets = "LUAD|LUSC") -> to_browse2

to_browse2
#> class: XenaHub 
#> hosts():
#>   https://tcga.xenahubs.net
#> cohorts() (2 total):
#>   TCGA Lung Adenocarcinoma (LUAD)
#>   TCGA Lung Squamous Cell Carcinoma (LUSC)
#> datasets() (2 total):
#>   TCGA.LUAD.sampleMap/LUAD_clinicalMatrix
#>   TCGA.LUSC.sampleMap/LUSC_clinicalMatrix
```

`XenaBrowse()` function can be used to browse dataset/cohort links using
your default web browser. At default, this function limits one
dataset/cohort for preventing user to open too many links at once.

``` r
# This will open you web browser
XenaBrowse(to_browse)

XenaBrowse(to_browse, type = "cohort")
```

``` r
# This will throw error
XenaBrowse(to_browse2)
#> Error in XenaBrowse(to_browse2): This function limite 1 dataset to browse.
#>  Set multiple to TRUE if you want to browse multiple links.

XenaBrowse(to_browse2, type = "cohort")
#> Error in XenaBrowse(to_browse2, type = "cohort"): This function limite 1 cohort to browse. 
#>  Set multiple to TRUE if you want to browse multiple links.
```

When you make sure you want to open multiple links, you can set
`multiple` option to `TRUE`.

``` r
XenaBrowse(to_browse2, multiple = TRUE)
XenaBrowse(to_browse2, type = "cohort", multiple = TRUE)
```

## Documentation

More features and usages please read [online
documentations](https://shixiangwang.github.io/home/en/tools/#ucscxenatools).

## APIs

API functions can be used to query specified data (e.g. expression of a
few genes for a few samples) or information instead of downloading the
entire dataset.

If you want to use APIs provided by **UCSCXenaTools** to access Xena
Hubs, please read [this
vignette](https://shixiangwang.github.io/home/en/tools/ucscxenatools-api/).

## Citation

Cite me by the following
    paper.

    Wang, Shixiang, et al. "The predictive power of tumor mutational burden 
        in lung cancer immunotherapy response is influenced by patients' sex." 
        International journal of cancer (2019).

Cite UCSC Xena by the following
    paper.

    Goldman, Mary, et al. "The UCSC Xena Platform for cancer genomics data 
        visualization and interpretation." BioRxiv (2019): 326470.

## Acknowledgments

This package is based on [XenaR](https://github.com/mtmorgan/XenaR),
thanks [Martin Morgan](https://github.com/mtmorgan) for his work.
