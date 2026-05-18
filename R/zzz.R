

.onLoad <- function(libname, pkgname) {
  
  # presetting DescTools options not already defined by the user
  op <- options()
  
  # not needed with new wrd env approach
  pkg.op <- list(
  #   hermes.lastWrd   = NULL,
  #   hermes.lastXL    = NULL,
  #   hermes.lastPP    = NULL
  )
  
  toset <- !(names(pkg.op) %in% names(op))
  if (any(toset)) options(pkg.op[toset])
  
}

utils::globalVariables("wdConst")


#' @importFrom bedrock setNamesX
#' @importFrom readxl read_xlsx
#' @importFrom writexl write_xlsx
#' @importFrom aurora strLeft strTrim
#'   
#' @import RDCOMClient
NULL           
