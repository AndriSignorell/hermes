
#' @export
xlDataTransferDialog <- function() {

  if (!requireNamespace("tcltk", quietly = TRUE)) {
    stop("tcltk not available")
  }

  res <- NULL

  ## --- Definitions ---------------------------------------------------
  # display label -> internal code
  structures <- c(
    "data.frame (colnames)"    = "data.frame",
    "data.frame (no colnames)" = "data.frame.nocol",
    "matrix"                   = "matrix",
    "table (dimnames)"         = "table",
    "list"                     = "list"
  )

  ## --- Toplevel ------------------------------------------------------
  tt <- tcltk::tktoplevel()
  tcltk::tkwm.withdraw(tt)   # hide until fully built (avoids blank window)
  tcltk::tkwm.title(tt, "Excel-Data-Transfer")
  tcltk::tkwm.resizable(tt, FALSE, FALSE)
  tcltk::tkwm.iconbitmap(tt, .getImg("R.ico"))

  ## --- Variables -----------------------------------------------------
  variable_var <- tcltk::tclVar("")
  result_var   <- tcltk::tclVar("code")

  ## --- Input block ---------------------------------------------------
  f <- tcltk::tkframe(tt, borderwidth = 2, relief = "groove")
  tcltk::tkpack(f, fill = "x", padx = 10, pady = c(10, 6))

  tcltk::tklabel(f, text = "Transfer selected Excel range to R") |>
    tcltk::tkpack(anchor = "w", padx = 5, pady = c(4, 6))

  g <- tcltk::tkframe(f)
  tcltk::tkpack(g, anchor = "w", padx = 10, pady = c(0, 8))

  structure_cb <- tcltk::ttkcombobox(
    g, values = names(structures), state = "readonly", width = 25
  )
  tcltk::tkset(structure_cb, names(structures)[1])

  variable_entry <- tcltk::ttkentry(
    g, textvariable = variable_var, width = 27
  )

  rframe <- tcltk::tkframe(g)
  tcltk::ttkradiobutton(
    rframe, text = "code", value = "code", variable = result_var
  ) |> tcltk::tkpack(side = "left", padx = c(0, 10))
  tcltk::ttkradiobutton(
    rframe, text = "data", value = "data", variable = result_var
  ) |> tcltk::tkpack(side = "left")

  tcltk::tkgrid(tcltk::tklabel(g, text = "structure:"), structure_cb,
                sticky = "w", padx = 5, pady = 3)
  tcltk::tkgrid(tcltk::tklabel(g, text = "variable:"), variable_entry,
                sticky = "w", padx = 5, pady = 3)
  tcltk::tkgrid(tcltk::tklabel(g, text = "result:"), rframe,
                sticky = "w", padx = 5, pady = 3)

  ## --- Buttons ---------------------------------------------------------
  bf <- tcltk::tkframe(tt)
  tcltk::tkpack(bf, pady = 10)

  btn_width <- 10

  ok_btn <- tcltk::ttkbutton(
    bf,
    text = "OK",
    width = btn_width,
    command = function() {
      res <<- list(
        structure = unname(structures[tcltk::tclvalue(tcltk::tkget(structure_cb))]),
        variable  = tcltk::tclvalue(variable_var),
        result    = tcltk::tclvalue(result_var)
      )
      tcltk::tkdestroy(tt)
    }
  )

  cancel_btn <- tcltk::ttkbutton(
    bf,
    text = "Cancel",
    width = btn_width,
    command = function() tcltk::tkdestroy(tt)
  )

  tcltk::tkpack(ok_btn,     side = "left", padx = 6)
  tcltk::tkpack(cancel_btn, side = "left", padx = 6)

  ## --- Key bindings ------------------------------------------------------
  tcltk::tkbind(tt, "<Return>", function() tcltk::tkinvoke(ok_btn))
  tcltk::tkbind(tt, "<Escape>", function() tcltk::tkdestroy(tt))

  ## --- Show window (after everything is built) ----------------------------
  tcltk::tcl("update", "idletasks")   # finish layout calculation

  ## position near mouse cursor
  x <- as.integer(tcltk::tclvalue(tcltk::tcl("winfo", "pointerx", ".")))
  y <- as.integer(tcltk::tclvalue(tcltk::tcl("winfo", "pointery", ".")))
  tcltk::tkwm.geometry(tt, paste0("+", x + 10, "+", y + 10))

  tcltk::tkwm.deiconify(tt)
  tcltk::tkraise(tt)
  tcltk::tcl("after", 50, function() {
    tcltk::tcl("focus", "-force", tt)
    tcltk::tkfocus(variable_entry)
  })

  ## --- Modal ---------------------------------------------------------------
  tcltk::tkwait.window(tt)

  res
}

