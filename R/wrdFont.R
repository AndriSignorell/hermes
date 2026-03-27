


wrdFont <- function(wrd) {
  
  # returns the font object list: list(name, size, bold, italic) 
  # on the current position
  
  sel <- wrd[["Selection"]]
  font <- sel[["Font"]]
  
  currfont <- list(
    name = font[["Name"]] ,
    size = font[["Size"]] ,
    bold = font[["Bold"]] ,
    italic = font[["Italic"]],
    color = setNamesX(font[["Color"]], names(which(
      wdConst==font[["Color"]] & grepl("wdColor", names(wdConst)))))
  )
  
  class(currfont) <- "font"
  return(currfont)
  
}


`wrdFont<-` <- function(wrd, value){
  
  sel <- wrd[["Selection"]]
  font <- sel[["Font"]]
  
  # set the new font
  if(!is.null(value$name)) font[["Name"]] <- value$name
  if(!is.null(value$size)) font[["Size"]] <- value$size
  if(!is.null(value$bold)) font[["Bold"]] <- value$bold
  if(!is.null(value$italic)) font[["Italic"]] <- value$italic
  if(!is.null(value$color)) font[["Color"]] <- value$color
  
  return(wrd)
  
}



