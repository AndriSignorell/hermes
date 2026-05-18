

# ================================================================
# Word session state (internal)
# ================================================================

.wrd_env <- new.env(parent = emptyenv())
.wrd_env$default <- NULL



# ================================================================
# Public API
# ================================================================


#' Create a New Word Session
#'
#' Starts a new Microsoft Word instance via RDCOMClient and creates
#' an empty document. The created instance is registered as the
#' current default Word session.
#'
#' @param visible Logical; whether the Word application should be visible.
#'
#' @return A Word COM object of class \code{"COMIDispatch"}.
#'
#' @details
#' The function initializes a Word application and ensures that at least
#' one document is open. The instance is stored internally and can be
#' accessed by other helper functions.
#'
#' @examples
#' \dontrun{
#' wrd <- newWrd()
#' }
#'

#' @export
newWrd <- function(visible = TRUE) {
  
  wrd <- .createCOMApp("Word.Application", visible = visible)
  wrd[["Visible"]] <- visible
  
  wrd[["Documents"]]$Add()
  
  # print(class(wrd))
  # print(wrd)
   
  setWrd(wrd)
  wrd
}




#' Set Current Word Session
#'
#' Registers a Word COM object as the current default session.
#'
#' @param wrd A Word COM object (class \code{"COMIDispatch"}).
#'
#' @return Invisibly returns \code{wrd}.
#'
#' @export
 
setWrd <- function(wrd) {
  
  if (!.isCOM(wrd)) {
    stop("Invalid Word COM object", call. = FALSE)
  }
  .wrd_env$default <- wrd
  invisible(wrd)
}




#' Get Current Word Session
#'
#' Retrieves the current Word COM object. If no valid session exists,
#' a new one can be created.
#'
#' @param create Logical; if \code{TRUE}, a new Word instance is created
#'   when none is available.
#'
#' @return A Word COM object or \code{NULL}.
#'

#' @export
getWrd <- function(create = TRUE) {
  
  .ensure_rdccomclient()
  
  wrd <- .wrd_env$default
  
  # 1. vorhandene Session prüfen
  if (.isValidWrd(wrd)) {
    .ensureDoc(wrd)
    return(wrd)
  }
  
  # 2. versuchen, bestehende Word-Instanz zu holen
  wrd <- tryCatch(
    RDCOMClient::getCOMInstance("Word.Application"),
    error = function(e) NULL
  )
  
  if (.isValidWrd(wrd)) {
    setWrd(wrd)
    .ensureDoc(wrd)
    return(wrd)
  }
  
  # 3. neue Instanz erstellen
  if (create) {
    wrd <- newWrd()
    return(wrd)
  }
  
  NULL
}




#' Temporarily Use a Word Session
#'
#' Evaluates an expression using a specified Word session as the default.
#'
#' @param wrd A Word COM object.
#' @param expr An expression to evaluate.
#'
#' @return The result of the evaluated expression.
#'
#' @examples
#' \dontrun{
#' withWrd(newWrd(), {
#'   toWrd("Hello")
#' })
#' }
#'

#' @export
withWrd <- function(wrd, expr) {
  
  old <- .wrd_env$default
  on.exit(.wrd_env$default <- old, add = TRUE)
  
  .wrd_env$default <- wrd
  
  eval.parent(substitute(expr))
}




#' Close Word Session
#'
#' Closes the current Word session and optionally saves open documents.
#'
#' @param save Logical; whether to save documents before closing.
#'
#' @return Invisibly returns \code{NULL}.
#'

#' @export
closeWrd <- function(save = FALSE) {
  
  wrd <- .wrd_env$default
  
  if (.isValidWrd(wrd)) {
    wrd$Quit(save)
  }
  
  .wrd_env$default <- NULL
  
  invisible(NULL)
}




# ================================================================
# Internal helpers
# ================================================================

#' @keywords internal
.createCOMApp <- function(app, visible = NULL) {
  
  .ensure_rdccomclient()
  
  if (Sys.info()[["sysname"]] != "Windows") {
    stop("COM is only available on Windows", call. = FALSE)
  }
  
  obj <- RDCOMClient::COMCreate(app)
  
  if (!inherits(obj, c("COMIDispatch", "COMObject"))) {
    stop(sprintf("Failed to create COM object: %s", app), call. = FALSE)
  }
  
  if (!is.null(visible)) {
    obj[["Visible"]] <- visible
  }
  
  obj
}



.ensure_rdccomclient <- function() {
  
  if (!requireNamespace("RDCOMClient", quietly = TRUE)) {
    stop("RDCOMClient is required but not installed", call. = FALSE)
  }
  
  if (!"package:RDCOMClient" %in% search()) {
    attachNamespace("RDCOMClient")
  }
  
  invisible(TRUE)
}




#' @keywords internal
.resolveWrd <- function(wrd) {
  if (missing(wrd) || is.null(wrd)) {
    getWrd()
  } else {
    wrd
  }
}


#' @keywords internal
.isCOM <- function(x) {
  inherits(x, c("COMIDispatch", "COMObject"))
}


#' @keywords internal
.isValidWrd <- function(wrd) {
  if (is.null(wrd)) return(FALSE)
  
  tryCatch({
    wrd[["Name"]]   # einfacher COM call
    TRUE
  }, error = function(e) FALSE)
}



#' @keywords internal
.ensureDoc <- function(wrd) {
  if (wrd[["Documents"]]$Count() == 0) {
    wrd[["Documents"]]$Add()
  }
}
