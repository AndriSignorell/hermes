
#' Word Constants for RDCOMClient
#'
#' A list of Microsoft Word constants used for automation via
#' \code{RDCOMClient}. These constants correspond to enumerations
#' defined in the Word object model and are used when calling
#' methods on Word COM objects.
#'
#' @format An object of class \code{"list"} containing named integer
#'   constants (e.g., \code{wdCollapseEnd}, \code{wdAlignParagraphLeft}, etc.).
#'
#' @details
#' The constants are intended for use with Word COM interfaces, for example:
#' \preformatted{
#' wrd[["Selection"]]$Collapse(Direction = wdConst$wdCollapseEnd)
#' }
#'
#' This avoids the need to manually define or remember numeric values
#' for Word enumerations.
#'
#' @examples
#' \dontrun{
#' # Collapse selection to end of document
#' wrd[["Selection"]]$Collapse(Direction = wdConst$wdCollapseEnd)
#'
#' # Apply paragraph alignment
#' wrd[["Selection"]]$ParagraphFormat()$Alignment <- wdConst$wdAlignParagraphLeft
#' }
#'
#' @seealso \code{\link{toWrd}}
#'
#' @keywords datasets
#' @usage wdConst
#' 
#' @name wdConst
NULL

