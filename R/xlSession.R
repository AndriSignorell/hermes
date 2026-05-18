
# ================================================================
# Excel session state (internal)
# ================================================================

.xl_env <- new.env(parent = emptyenv())
.xl_env$default <- NULL



# ================================================================
# Public API
# ================================================================


#' Create a New Excel Session
#'
#' Starts a new Microsoft Excel instance via RDCOMClient.
#' The created instance is registered as the current default
#' Excel session.
#'
#' @param visible Logical; whether the Excel application should
#'   be visible.
#'
#' @return An Excel COM object of class \code{"COMIDispatch"}.
#'
#' @examples
#' \dontrun{
#' xl <- newXl()
#' }
#'
#' @export
newXl <- function(visible = TRUE) {
  
  xl <- .createCOMApp(
    "Excel.Application",
    visible = visible
  )
  
  xl[["Visible"]] <- visible
  
  setXl(xl)
  
  xl
}




#' Set Current Excel Session
#'
#' Registers an Excel COM object as the current default session.
#'
#' @param xl An Excel COM object.
#'
#' @return Invisibly returns \code{xl}.
#'
#' @export
setXl <- function(xl) {
  
  if (!.isCOM(xl)) {
    stop("Invalid Excel COM object.", call. = FALSE)
  }
  
  .xl_env$default <- xl
  
  invisible(xl)
}




#' Get Current Excel Session
#'
#' Retrieves the current Excel COM object. If no valid session exists,
#' a new one can optionally be created.
#'
#' @param create Logical; if \code{TRUE}, a new Excel instance is
#'   created when none is available.
#'
#' @return An Excel COM object or \code{NULL}.
#'
#' @export
getXl <- function(create = TRUE) {
  
  xl <- .xl_env$default
  
  # existing valid session
  if (.isValidXl(xl)) {
    return(xl)
  }
  
  # try existing Excel instance
  xl <- tryCatch(
    RDCOMClient::getCOMInstance("Excel.Application"),
    error = function(e) NULL
  )
  
  if (.isValidXl(xl)) {
    
    setXl(xl)
    
    return(xl)
  }
  
  # create new instance
  if (create) {
    return(newXl())
  }
  
  NULL
}




#' Temporarily Use an Excel Session
#'
#' Evaluates an expression using a specified Excel session as the
#' default.
#'
#' @param xl An Excel COM object.
#' @param expr An expression to evaluate.
#'
#' @return The result of the evaluated expression.
#'
#' @export
withXl <- function(xl, expr) {
  
  old <- .xl_env$default
  
  on.exit(.xl_env$default <- old, add = TRUE)
  
  .xl_env$default <- xl
  
  eval.parent(substitute(expr))
}




#' Close Excel Session
#'
#' Closes the current Excel session.
#'
#' @param save logical should the save dialog be displayed?
#' @return Invisibly returns \code{NULL}.
#'
#' @export
closeXl <- function(save = FALSE) {
  
  xl <- .xl_env$default
  
  if (.isValidXl(xl)) {
    xl$Quit(save)
  }
  
  .xl_env$default <- NULL
  
  invisible(NULL)
}




#' View a Data Frame in Excel
#'
#' Opens a data frame in Microsoft Excel for interactive inspection.
#'
#' A new workbook and worksheet are created automatically.
#'
#' @param x A data frame.
#' @param sheet Optional worksheet name.
#' @param rowNames Logical; if \code{TRUE}, row names are included.
#' @param table Logical; if \code{TRUE}, Excel filters are enabled.
#' @param autofit Logical; if \code{TRUE}, column widths are adjusted
#'   automatically.
#' @param freeze Logical; if \code{TRUE}, the first row is frozen.
#' @param xl Optional Excel COM object.
#'
#' @details
#' Data are transferred column-wise to preserve numeric types.
#' Factors and date-time objects are converted to character vectors.
#'
#' The workbook is not saved automatically.
#'
#' @return Invisibly returns the worksheet COM object.
#'
#' @examples
#' \dontrun{
#' xlView(iris)
#' xlView(mtcars)
#' }
#'
#' @family spreadsheet.utils
#' @concept excel
#' @concept spreadsheet
#' @concept data-inspection
#'
#' @export
xlView <- function(x,
                   sheet = deparse(substitute(x)),
                   rowNames = FALSE,
                   table = TRUE,
                   autofit = TRUE,
                   freeze = TRUE,
                   xl = NULL) {
  
  if (!is.data.frame(x)) {
    stop("'x' must be a data.frame.", call. = FALSE)
  }
  
  if (is.null(xl)) {
    xl <- getXl()
  }
  
  xl[["Visible"]] <- TRUE
  
  # --- create workbook ---------------------------------------------
  
  wb <- xl[["Workbooks"]]$Add()
  
  ws <- wb$Worksheets(1)
  
  # sanitize worksheet name
  sheet <- substr(
    gsub("[:\\\\/?*\\[\\]]", "_", sheet),
    1L,
    31L
  )
  
  ws[["Name"]] <- sheet
  
  # --- normalize data ----------------------------------------------
  
  x <- .asExcelDataFrame(
    x,
    rowNames = rowNames
  )
  
  nRow <- nrow(x)
  nCol <- ncol(x)
  
  # --- write header ------------------------------------------------
  
  hdrMat <- matrix(
    colnames(x),
    nrow = 1L
  )
  
  hdrRng <- ws$Range(
    ws$Cells(1, 1),
    ws$Cells(1, nCol)
  )
  
  hdrRng[["Value"]] <- RDCOMClient::asCOMArray(hdrMat)
  
  # --- write data column-wise --------------------------------------
  
  for (j in seq_len(nCol)) {
    
    val <- matrix(
      x[[j]],
      ncol = 1L
    )
    
    rng <- ws$Range(
      ws$Cells(2, j),
      ws$Cells(nRow + 1L, j)
    )
    
    rng[["Value"]] <- RDCOMClient::asCOMArray(val)
  }
  
  # --- used range --------------------------------------------------
  
  used <- ws$Range(
    ws$Cells(1, 1),
    ws$Cells(nRow + 1L, nCol)
  )
  
  # --- filters -----------------------------------------------------
  
  if (table) {
    used$AutoFilter()
  }
  
  # --- minimal header styling --------------------------------------
  
  hdr <- ws$Range(
    ws$Cells(1, 1),
    ws$Cells(1, nCol)
  )
  
  font <- hdr[["Font"]]
  
  font[["Bold"]] <- TRUE
  font[["ColorIndex"]] <- 1
  
  # bottom border
  # 9 = xlEdgeBottom
  b <- hdr$Borders(9)
  
  b[["LineStyle"]] <- 1
  b[["Weight"]] <- 2
  
  # --- autofit -----------------------------------------------------
  
  if (autofit) {
    used$Columns()$AutoFit()
  }
  
  # --- freeze header row -------------------------------------------
  
  ws$Activate()
  
  if (freeze) {
    .freezeTopRow(xl)
  }
  
  # no save dialogs when leaving...
  wb[["Saved"]] <- TRUE
  
  # xl$Activate()
  
  invisible(ws)
}




# ================================================================
# Internal helpers
# ================================================================


#' @keywords internal
.freezeTopRow <- function(xl, n = 1L) {
  
  win <- xl[["ActiveWindow"]]
  
  if (is.null(win)) {
    return(invisible(FALSE))
  }
  
  win[["SplitRow"]] <- n
  win[["FreezePanes"]] <- TRUE
  
  invisible(TRUE)
}




#' @keywords internal
.isValidXl <- function(xl) {
  
  if (is.null(xl)) {
    return(FALSE)
  }
  
  tryCatch({
    xl[["Name"]]
    TRUE
  }, error = function(e) FALSE)
}




#' @keywords internal
.asExcelDataFrame <- function(x, rowNames = FALSE) {
  
  x <- as.data.frame(
    x,
    stringsAsFactors = FALSE
  )
  
  x[] <- lapply(x, function(z) {
    
    if (inherits(z, "factor")) {
      z <- as.character(z)
    }
    
    if (inherits(z, c("POSIXct", "POSIXlt"))) {
      z <- as.character(z)
    }
    
    if (inherits(z, "Date")) {
      z <- as.character(z)
    }
    
    z
  })
  
  if (rowNames) {
    
    x <- cbind(
      Row = rownames(x),
      x,
      stringsAsFactors = FALSE
    )
    
  }
  
  x
}