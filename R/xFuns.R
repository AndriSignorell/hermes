

#' xXlView
#' Run xlView() on selected text.
#' @export
xXlView <- function()  .execFunction("hermes::xlView")




# == internal helper functions =================================================

.execFunction <- function(FUN) {
  
  requireNamespace("hermes")
  
  if (!rstudioapi::isAvailable()) {
    stop("RStudio API not available.")
  }
  
  sel <- rstudioapi::getActiveDocumentContext()$
    selection[[1]]$text
  
  if (nzchar(sel)) {
    rstudioapi::sendToConsole(
      sprintf("%s(%s)", FUN, sel),
      execute = TRUE,
      focus = FALSE
    )
  } else {
    message("No selection!")
  }
}


