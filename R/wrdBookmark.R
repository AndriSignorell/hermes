



# wrdBookmark <- function(name, wrd = NULL) {
#   
#   wrd <- .resolveWrd(wrd)
#   
#   wrd[["ActiveDocument"]]$Bookmarks(name)$Select()
# }
# 



wrdBookmark <- function(name, wrd = NULL){
  
  wrd <- .resolveWrd(wrd)
  
  wbms <- wrd[["ActiveDocument"]][["Bookmarks"]]
  
  if(wbms$count()>0){
    # get bookmark names
    bmnames <- sapply(seq(wbms$count()), function(i) wbms[[i]]$name())
    
    id <- which(name == bmnames)
    
    if(length(id)==0)   # name found?
      res <- NULL 
    
    else
      res <- wbms[[id]]
    # no attributes for S4 objects... :-(
    #  res@idx <- which(name == bmnames)
    
  } else {
    # warning(gettextf("bookmark %s not found", bookmark))
    res <- NULL
  }
  
  return(res)  
  
}
