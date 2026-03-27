
wrdDeleteBookmark <- function(name, wrd = NULL){
  
  wrd <- .resolveWrd(wrd)
  
  wrdBookmarks <- wrd[["ActiveDocument"]][["Bookmarks"]]
  if(wrdBookmarks$exists(name)){
    wrdBookmark(name)$Delete()
    res <- TRUE
  } else {
    warning(gettextf("Bookmark %s does not exist, so there's nothing to delete", name))
    res <- FALSE
  }
  
  return(res)
  # TRUE for success / FALSE for fail
}  

