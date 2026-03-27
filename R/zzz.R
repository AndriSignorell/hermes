

.onLoad <- function(libname, pkgname) {
  
  # presetting DescTools options not already defined by the user
  op <- options()
  
  pkg.op <- list(
    DescToolsX.lastWrd   = NULL,
    DescToolsX.lastXL    = NULL,
    DescToolsX.lastPP    = NULL
  )
  
  toset <- !(names(pkg.op) %in% names(op))
  if (any(toset)) options(pkg.op[toset])
  
}

utils::globalVariables("wdConst")


#' @importFrom bedrock setNamesX
#' @importFrom readxl read_xlsx
#' @importFrom writexl write_xlsx
#'  
#' @import RDCOMClient
NULL           
