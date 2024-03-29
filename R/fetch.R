#' Fetch Data from UCSC Xena Hosts
#'
#' When you want to query just data for several genes/samples from UCSC Xena datasets, a better way
#' is to use these `fetch_` functions instead of downloading a whole dataset. Details about functions
#' please see the following sections.
#'
#' There are three primary data types: dense matrix (samples by probes (or say identifiers)),
#' sparse (sample, position, variant), and segmented (sample, position, value).
#'
#' Dense matrices can be genotypic or phenotypic, it is a sample-by-identifiers matrix.
#' Phenotypic matrices have associated field metadata (descriptive names, codes, etc.).
#' Genotypic matricies may have an associated probeMap, which maps probes to genomic locations.
#' If a matrix has hugo probeMap, the probes themselves are gene names. Otherwise, a probeMap is
#' used to map a gene location to a set of probes.
#'
#' @param host a UCSC Xena host, like "https://toil.xenahubs.net".
#' All available hosts can be printed by [xena_default_hosts()].
#' @param dataset a UCSC Xena dataset, like "tcga_RSEM_gene_tpm".
#' All available datasets can be printed by running `XenaData$XenaDatasets` or
#' obtained from [UCSC Xena datapages](https://xenabrowser.net/datapages/).
#' @param identifiers Identifiers could be probe (like "ENSG00000000419.12"),
#' gene (like "TP53") etc.. If it is `NULL`, all identifiers in the dataset will be used.
#' @param samples ID of samples, like "TCGA-02-0047-01".
#' If it is `NULL`, all samples in the dataset will be used. However, it is better to download
#' the whole datasets if you query many samples and genes.
#' @param check if `TRUE`, check whether specified `identifiers` and `samples` exist the dataset
#' (all failed items will be filtered out). However, if `FALSE`, the code is much faster.
#' @param use_probeMap if `TRUE`, will check if the dataset has ProbeMap firstly.
#' When the dataset you want to query has a identifier-to-gene mapping, identifiers can be
#' gene symbols even the identifiers of dataset are probes or others.
#' @param time_limit time limit for getting response in seconds.
#' @return a `matirx` or character vector or a `list`.
#' @examples
#' library(UCSCXenaTools)
#'
#' host <- "https://toil.xenahubs.net"
#' dataset <- "tcga_RSEM_gene_tpm"
#' samples <- c("TCGA-02-0047-01", "TCGA-02-0055-01", "TCGA-02-2483-01", "TCGA-02-2485-01")
#' probes <- c("ENSG00000282740.1", "ENSG00000000005.5", "ENSG00000000419.12")
#' genes <- c("TP53", "RB1", "PIK3CA")
#'
#' \donttest{
#' # Fetch samples
#' fetch_dataset_samples(host, dataset, 2)
#' # Fetch identifiers
#' fetch_dataset_identifiers(host, dataset)
#' # Fetch expression value by probes
#' fetch_dense_values(host, dataset, probes, samples, check = FALSE)
#' # Fetch expression value by gene symbol (if the dataset has probeMap)
#' has_probeMap(host, dataset)
#' fetch_dense_values(host, dataset, genes, samples, check = FALSE, use_probeMap = TRUE)
#' }
#' @export
fetch <- function(host, dataset) {
  message("This function is used to build consistent documentation.")
  message("Please use a function starts with fetch_")
}

check_hiplot <- function(host) {
  use_hiplot <- getOption("use_hiplot", default = FALSE)
  if (use_hiplot) {
      # Check website status
      use_hiplot <- tryCatch(
          {
              httr::http_error(host)
              TRUE
          },
          error = function(e) {
              message("The hiplot server may down, we will not use it for now.")
              FALSE
          }
      )
  }
  if (use_hiplot) {
    if (!grepl("hiplot", host)) {
      message("Use hiplot server (China) for mirrored data hubs (set 'options(use_hiplot = FALSE)' to disable it)")
      host2 <- as.character(.xena_mirror_map_rv[host])
      if (!is.na(host2)) {
        host <- host2
      }
    }
  }
  return(host)
}

#' @describeIn fetch fetches values from a dense matrix.
#' @export
fetch_dense_values <- function(host, dataset, identifiers = NULL, samples = NULL,
                               check = TRUE, use_probeMap = FALSE, time_limit = 30) {
  stopifnot(
    length(host) == 1, length(dataset) == 1,
    is.character(host), is.character(dataset),
    is.logical(check), is.logical(use_probeMap)
  )
  .attach_this()

  host <- check_hiplot(host)
  if (check) {
    # obtain all samples
    all_samples <- fetch_dataset_samples(host, dataset)
    # obtain all identifiers
    use_probe <- use_probeMap && has_probeMap(host, dataset)
    if (use_probe) {
        message("-> Obtaining gene symbols from probeMap...")
        url <- has_probeMap(host, dataset, return_url = TRUE)
        all_identifiers <- use_cache(url, op = "readr::read_tsv(url,
            col_types = readr::cols()
        )[[2]]")
    } else {
        all_identifiers <- fetch_dataset_identifiers(host, dataset)
    }

    message("-> Checking identifiers...")
    if (is.null(identifiers)) {
      identifiers <- all_identifiers
    } else {
      if (!is.character(identifiers)) stop("Bad type for identifiers.")
      if (!all(identifiers %in% all_identifiers)) {
        which_in <- identifiers %in% all_identifiers
        message("The following identifiers have been removed from host ", host, " dataset ", dataset)
        print(identifiers[!which_in])
        identifiers <- identifiers[which_in]
        if (length(identifiers) == 0) {
          stop("Bad identifiers, no one left, check input?")
        }
      }
    }
    message("-> Done.")

    message("-> Checking samples...")
    if (is.null(samples)) {
      samples <- all_samples
    } else {
      if (!is.character(samples)) stop("Bad type for samples.")
      if (!all(samples %in% all_samples)) {
        which_in <- samples %in% all_samples
        message("The following samples have been removed from host ", host, " dataset ", dataset)
        print(samples[!which_in])
        samples <- samples[which_in]
        if (length(samples) == 0) {
          stop("Bad samples, no one left, check input?")
        }
      }
    }
    message("-> Done.")
  } else {
    if (is.null(samples)) {
      # obtain all samples
      samples <- fetch_dataset_samples(host, dataset)
    }
    if (is.null(identifiers)) {
      # obtain all identifiers
      identifiers <- fetch_dataset_identifiers(host, dataset)
    }
  }


  if (length(samples) == 1) {
    samples <- as.list(samples)
  }
  if (length(identifiers) == 1) {
    identifiers <- as.list(identifiers)
  }

  if (use_probeMap) {
    message("-> Checking if the dataset has probeMap...")
    if (has_probeMap(host, dataset)) {
      message("-> Done. ProbeMap is found.")

      t_start = Sys.time()
      while (as.numeric(Sys.time() - t_start) < time_limit) {
        res <- tryCatch(
          {
            .p_dataset_gene_probe_avg(host, dataset, samples, identifiers)
          },
          error = function(e) {
            message("-> Query faild. Retrying...")
            list(has_error = TRUE, error_info = e)
          }
        )
        if (is.data.frame(res)) {
          break()
        }
        Sys.sleep(1)
      }

      if (!is.data.frame(res)) {
        stop(paste(
          "The response times out and still returns an error",
          res$error_info$message,
          sep = "\n"
        ))
      }

      if (!is.null(unlist(res[["scores"]]))) {
        res <- t(sapply(res[["scores"]], base::rbind))
        rownames(res) <- identifiers
        colnames(res) <- samples
        return(res)
      }
    }
    message("-> Done. No probeMap found or error happened, use old way...")
  }

  t_start = Sys.time()
  while (as.numeric(Sys.time() - t_start) < time_limit) {
    res <- tryCatch(
      {
        .p_dataset_fetch(host, dataset, samples, identifiers)
      },
      error = function(e) {
        message("-> Query faild. Retrying...")
        list(has_error = TRUE, error_info = e)
      }
    )
    if (is.atomic(res)) {
      break()
    }
    Sys.sleep(1)
  }

  if (!is.atomic(res)) {
    stop(paste(
      "The response times out and still returns an error",
      res$error_info$message,
      sep = "\n"
    ))
  }

  message("-> Query done.")
  rownames(res) <- identifiers
  colnames(res) <- samples
  res
}

#' @describeIn fetch fetches values from a sparse `data.frame`.
#' @param genes gene names.
#' @export
fetch_sparse_values <- function(host, dataset, genes, samples = NULL,
                               time_limit = 30) {
  # fetch_sparse_values("https://ucscpublic.xenahubs.net", "ccle/CCLE_DepMap_18Q2_maf_20180502", c("TP53", "KRAS")) -> mm
  stopifnot(
    length(host) == 1, length(dataset) == 1,
    is.character(host), is.character(dataset)
  )
  .attach_this()

  host <- check_hiplot(host)
  if (is.null(samples)) {
    samples <- fetch_dataset_samples(host, dataset)
  }

  t_start = Sys.time()
  while (as.numeric(Sys.time() - t_start) < time_limit) {
    res <- tryCatch(
      {
        .p_sparse_data(host, dataset, samples, genes)
      },
      error = function(e) {
        message("-> Query faild. Retrying...")
        list(has_error = TRUE, error_info = e)
      }
    )
    if (is.list(res)) {
      break()
    }
    Sys.sleep(1)
  }

  res
}

#' @describeIn fetch fetches samples from a dataset
#' @param limit number of samples, if `NULL`, return all samples.
#' @export
fetch_dataset_samples <- function(host, dataset, limit = NULL) {
  .attach_this()
  host <- check_hiplot(host)
  .p_dataset_samples(host = host, dataset = dataset, limit = limit)
}

#' @describeIn fetch fetches identifies from a dataset.
#' @export
fetch_dataset_identifiers <- function(host, dataset) {
  .attach_this()
  host <- check_hiplot(host)
  .p_dataset_field(host = host, dataset = dataset)
}

#' @describeIn fetch checks if a dataset has ProbeMap.
#' @param return_url if `TRUE`, returns the info of probeMap
#' instead of a logical value when the result exists.
#' @export
has_probeMap <- function(host, dataset, return_url = FALSE) {
  .attach_this()
  if (! host %in% .xena_mirror_map) {
    host <- .xena_mirror_map[host]
  }
  df <- base::subset(UCSCXenaTools::XenaData, XenaHosts == host & XenaDatasets == dataset)
  rv <- !is.na(df[["ProbeMap"]])
  if (rv && return_url) {
      paste0(
          df$XenaHosts, "/download/",
          df[["ProbeMap"]]
      )
  } else rv
}

utils::globalVariables(
  c(
    ".p_dataset_fetch", ".p_dataset_field", ".p_dataset_gene_probe_avg",
    ".p_dataset_samples", ".p_sparse_data"
  )
)
