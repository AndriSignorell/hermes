


# == internal helper functions for tcltk dialogs ===============================

.initDlg <- function(width, height, x=NULL, y=NULL, resizex=FALSE, 
                     resizey=FALSE, main="Dialog", ico="R"){
  
  top <- tcltk::tktoplevel()
  
  # Alternative for Windows:
  # if(Sys.info()["sysname"]=="Windows") {
  #   res <- system("wmic path Win32_VideoController get CurrentVerticalResolution,CurrentHorizontalResolution /format:value", intern = TRUE)
  #   res <- as.integer(StrExtract(grep("Cur", res, val=TRUE), "[0-9]+"))
  #   if(is.null(x)) x <- round(res[1]/2 - 50)
  #   if(is.null(y)) y <- round(res[2]/2 - 25)
  # }
  
  # if(is.null(x)) x <- as.integer(tcltk::tkwinfo("screenwidth", top))/2 - 50
  # if(is.null(y)) y <- as.integer(tcltk::tkwinfo("screenheight", top))/2 - 25
  
  if(is.null(x)) x <- round((as.integer(tcltk::tkwinfo("screenwidth", top)) - width)/2)
  if(is.null(y)) y <- round((as.integer(tcltk::tkwinfo("screenheight", top)) - height)/2)
  
  geom <- gettextf("%sx%s+%s+%s", width, height, x, y)
  tcltk::tkwm.geometry(top, geom)
  tcltk::tkwm.title(top, main)
  tcltk::tkwm.resizable(top, resizex, resizey)
  # alternative:
  #    system.file("extdata", paste(ico, "ico", sep="."), package="DescTools")
  tcltk::tkwm.iconbitmap(top, .getImg(paste(ico, "ico", sep=".")))
  
  return(top)
  
}


.getImg <- function(fname){
  
  # looks for files either in /extdata  or in /inst/extdata
  path <- find.package(.thisPackage())
  
  res <- file.path(path, "extdata", fname)
  if(file.exists(res))
    return(res)
  
  res <- file.path(path, "inst","extdata", fname)
  if(file.exists(res))
    return(res)
  
  warning(gettextf("File %s not found in package folders."))
  
}



.thisPackage <- function() {
  ns <- topenv(environment())
  
  if (identical(ns, globalenv())) {
    return(NULL)
  }
  
  tryCatch(
    getNamespaceName(ns),
    error = function(e) NULL
  )
}



.bringToFront <- function(main){
  
  info_sys <- Sys.info() # sniff the O.S.
  
  if (info_sys['sysname'] == 'Windows') { # MS Windows trick
    shell(gettextf("powershell -command [void] [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') ; [Microsoft.VisualBasic.Interaction]::AppActivate('%s') ", main))
  }
  
}


.simpEntryDlg <- function(text, default, main){
  
  requireNamespace("tcltk", quietly = FALSE)
  
  e1 <- environment()
  txt <- character()
  
  tfpw <- tcltk::tclVar("")
  
  OnOK <- function() {
    assign("txt", tcltk::tclvalue(tfpw), envir = e1)
    tcltk::tkdestroy(root)
  }
  
  # do not update screen
  tcltk::tclServiceMode(on = FALSE)
  
  # create window
  root <- .initDlg(205, 110, resizex=FALSE, resizey=FALSE, main=main, ico="R")
  
  # define widgets
  content <- tcltk::tkframe(root, padx=10, pady=10)
  tfEntrPW <- tcltk::tkentry(content, width="30", textvariable=tfpw)
  tfButOK <- tcltk::tkbutton(content,text="OK", command=OnOK, width=6)
  tfButCanc <- tcltk::tkbutton(content, text="Cancel", width=7,
                               command=function() tcltk::tkdestroy(root))
  
  # build GUI
  tcltk::tkgrid(content, column=0, row=0)
  tcltk::tkgrid(tcltk::tklabel(content, text=text), column=0, row=0,
                columnspan=3, sticky="w")
  tcltk::tkgrid(tfEntrPW, column=0, row=1, columnspan=3, pady=10)
  tcltk::tkgrid(tfButOK, column=0, row=2, ipadx=15, sticky="w")
  tcltk::tkgrid(tfButCanc, column=2, row=2, ipadx=5, sticky="e")
  
  # binding event-handler
  tcltk::tkbind(tfEntrPW, "<Return>", OnOK)
  
  tcltk::tkfocus(tfEntrPW)
  tcltk::tclServiceMode(on = TRUE)
  
  tcltk::tcl("wm", "attributes", root, topmost=TRUE)
  
  tcltk::tkwait.window(root)
  
  return(txt)
  
}



