


wrdStyle <- function (wrd) {
  
  wrdSel <- wrd[["Selection"]]
  wrdStyle <- wrdSel[["Style"]][["NameLocal"]]
  
  return(wrdStyle)
}


`wrdStyle<-` <- function (wrd, value) {
  wrdSel <- wrd[["Selection"]][["Paragraphs"]]
  wrdSel[["Style"]] <- value
  
  return(wrd)
  
}

