
#' Go to a Word Object
#'
#' Moves the current Word selection to a specified object,
#' such as a bookmark.
#'
#' @param name Name of the target object.
#' @param what Word GoTo constant defining the target type.
#'   Defaults to \code{wdConst$wdGoToBookmark}.
#' @param wrd A Word COM object. If \code{NULL}, the current
#'   active Word session is used.
#'
#' @details
#' The function moves the current Word selection to the
#' specified target object using Word's \code{GoTo()} method.
#'
#' When navigating to bookmarks, existence of the bookmark
#' is checked before attempting the navigation.
#'
#' @return
#' Invisibly returns \code{TRUE} on success and
#' \code{FALSE} if the target bookmark does not exist.
#'
#' @examples
#' \dontrun{
#' wrdGoto("intro")
#' }
#'

#' @export
wrdGoto <- function(name,
                    what = NULL,
                    wrd = NULL) {
  
  # do not remove, as add-ins mihgt need it even if not yet loaded
  requireNamespace("hermes")
  
  wrd <- .resolveWrd(wrd)
  
  if (is.null(what)) {
    what <- hermes::wdConst$wdGoToBookmark
  }
  
  wrdSel <- wrd[["Selection"]]
  
  if (what == hermes::wdConst$wdGoToBookmark) {
    
    bookmarks <- .bookmarks(wrd)
    
    if (!bookmarks$Exists(name)) {
      
      warning(
        gettextf(
          "Bookmark %s does not exist, so there's nothing to select",
          name
        )
      )
      
      return(invisible(FALSE))
    }
  }
  
  wrdSel$GoTo(What = what, Name = name)
  
  invisible(TRUE)
}

