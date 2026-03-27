

# Get and set ParagraphFormat

wrdPara <- function(wrd) {
  
  wrdPar <- wrd[["Selection"]][["ParagraphFormat"]]
  
  currpar <- list(
    LeftIndent               =wrdPar[["LeftIndent"]] ,
    RightIndent              =wrdPar[["RightIndent"]] ,
    SpaceBefore              =wrdPar[["SpaceBefore"]] ,
    SpaceBeforeAuto          =wrdPar[["SpaceBeforeAuto"]] ,
    SpaceAfter               =wrdPar[["SpaceAfter"]] ,
    SpaceAfterAuto           =wrdPar[["SpaceAfterAuto"]] ,
    LineSpacingRule          =wrdPar[["LineSpacingRule"]],
    Alignment                =wrdPar[["Alignment"]],
    WidowControl             =wrdPar[["WidowControl"]],
    KeepWithNext             =wrdPar[["KeepWithNext"]],
    KeepTogether             =wrdPar[["KeepTogether"]],
    PageBreakBefore          =wrdPar[["PageBreakBefore"]],
    NoLineNumber             =wrdPar[["NoLineNumber"]],
    Hyphenation              =wrdPar[["Hyphenation"]],
    FirstLineIndent          =wrdPar[["FirstLineIndent"]],
    OutlineLevel             =wrdPar[["OutlineLevel"]],
    CharacterUnitLeftIndent  =wrdPar[["CharacterUnitLeftIndent"]],
    CharacterUnitRightIndent =wrdPar[["CharacterUnitRightIndent"]],
    CharacterUnitFirstLineIndent=wrdPar[["CharacterUnitFirstLineIndent"]],
    LineUnitBefore           =wrdPar[["LineUnitBefore"]],
    LineUnitAfter            =wrdPar[["LineUnitAfter"]],
    MirrorIndents            =wrdPar[["MirrorIndents"]]
    # wrdPar[["TextboxTightWrap"]] <- TextboxTightWrap
  )
  
  class(currpar) <- "paragraph"
  return(currpar)
}



`wrdPara<-` <- function(wrd, value){
  
  wrdPar <- wrd[["Selection"]][["ParagraphFormat"]]
  
  # set the new font
  if(!is.null(value$LeftIndent)) wrdPar[["LeftIndent"]] <- value$LeftIndent
  if(!is.null(value$RightIndent)) wrdPar[["RightIndent"]] <- value$RightIndent
  if(!is.null(value$SpaceBefore)) wrdPar[["SpaceBefore"]] <- value$SpaceBefore
  if(!is.null(value$SpaceBeforeAuto)) wrdPar[["SpaceBeforeAuto"]] <- value$SpaceBeforeAuto
  if(!is.null(value$SpaceAfter)) wrdPar[["SpaceAfter"]] <- value$SpaceAfter
  if(!is.null(value$SpaceAfterAuto)) wrdPar[["SpaceAfterAuto"]] <- value$SpaceAfterAuto
  if(!is.null(value$LineSpacingRule)) wrdPar[["LineSpacingRule"]] <- value$LineSpacingRule
  if(!is.null(value$Alignment)) {
    if(is.character(value$Alignment))
      switch(match.arg(value$Alignment, choices = c("left","center","right"))
             , left=value$Alignment <- wdConst$wdAlignParagraphLeft
             , center=value$Alignment <- wdConst$wdAlignParagraphCenter
             , right=value$Alignment <- wdConst$wdAlignParagraphRight
      )
    wrdPar[["Alignment"]] <- value$Alignment
  }
  if(!is.null(value$WidowControl)) wrdPar[["WidowControl"]] <- value$WidowControl
  if(!is.null(value$KeepWithNext)) wrdPar[["KeepWithNext"]] <- value$KeepWithNext
  if(!is.null(value$KeepTogether)) wrdPar[["KeepTogether"]] <- value$KeepTogether
  if(!is.null(value$PageBreakBefore)) wrdPar[["PageBreakBefore"]] <- value$PageBreakBefore
  if(!is.null(value$NoLineNumber)) wrdPar[["NoLineNumber"]] <- value$NoLineNumber
  if(!is.null(value$Hyphenation)) wrdPar[["Hyphenation"]] <- value$Hyphenation
  if(!is.null(value$FirstLineIndent)) wrdPar[["FirstLineIndent"]] <- value$FirstLineIndent
  if(!is.null(value$OutlineLevel)) wrdPar[["OutlineLevel"]] <- value$OutlineLevel
  if(!is.null(value$CharacterUnitLeftIndent)) wrdPar[["CharacterUnitLeftIndent"]] <- value$CharacterUnitLeftIndent
  if(!is.null(value$CharacterUnitRightIndent)) wrdPar[["CharacterUnitRightIndent"]] <- value$CharacterUnitRightIndent
  if(!is.null(value$CharacterUnitFirstLineIndent)) wrdPar[["CharacterUnitFirstLineIndent"]] <- value$CharacterUnitFirstLineIndent
  if(!is.null(value$LineUnitBefore)) wrdPar[["LineUnitBefore"]] <- value$LineUnitBefore
  if(!is.null(value$LineUnitAfter)) wrdPar[["LineUnitAfter"]] <- value$LineUnitAfter
  if(!is.null(value$MirrorIndents)) wrdPar[["MirrorIndents"]] <- value$MirrorIndents
  
  return(wrd)
  
}

