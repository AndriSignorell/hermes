#' Excel Data Transfer Dialog
#'
#' Modal Tcl/Tk dialog that asks the user how to organize and deliver an Excel
#' range that is being transferred to R. It is the interactive front-end used by
#' \code{\link{xlImport}} and returns the user's choices as a plain list.
#'
#' The dialog shows the selected range address, a structure chooser, a variable
#' name entry, and an "insert data at cursor position" checkbox.
#'
#' The offered structures are:
#' \describe{
#'   \item{data.frame (colnames)}{first row becomes the column names.}
#'   \item{data.frame (no colnames)}{base-R default names \code{V1, V2, ...}.}
#'   \item{matrix}{whole range as a matrix.}
#'   \item{table (dimnames)}{first column / first row as dim names.}
#'   \item{list}{one component per column.}
#' }
#' When \code{multi = TRUE} (a disjoint multi-area selection), only the
#' column-combinable structures are offered - the two \code{data.frame} variants
#' and \code{list} - and \code{list} is preselected, because \code{matrix} and
#' \code{table} are not defined across several areas (see
#' \code{\link{xlParseRange}}).
#'
#' @param range character; the range address to display in the header label,
#'   e.g. \code{"A1:B34; C23:E55"}. \code{NULL} or empty shows
#'   \code{"(no selection)"}.
#' @param multi logical; \code{TRUE} if several disjoint areas are selected.
#'   Restricts the structure choices and preselects \code{"list"}.
#'
#' @return A list with components
#'   \describe{
#'     \item{structure}{internal structure code: one of \code{"data.frame"},
#'       \code{"data.frame.nocol"}, \code{"matrix"}, \code{"table"},
#'       \code{"list"}.}
#'     \item{variable}{the variable name typed by the user (possibly \code{""}).}
#'     \item{insert}{logical; whether "insert at cursor position" was checked.}
#'   }
#'   Returns \code{NULL} if the dialog is cancelled (Cancel button or Escape).
#'
#' @seealso \code{\link{xlImport}}
#'
#' @examples
#' \dontrun{
#' res <- xlDataTransferDialog(range = "A1:B34")
#' str(res)
#' }
#'
#' @export
xlDataTransferDialog <- function(range = NULL, multi = FALSE) {

  # Header label text; guard against NULL / empty.
  if (is.null(range) || !nzchar(range))
    range <- "(no selection)"

  if (!requireNamespace("tcltk", quietly = TRUE)) {
    stop("tcltk not available")
  }

  res <- NULL   # filled by the OK handler; stays NULL on cancel

  ## --- Definitions ----------------------------------------------------------
  # Display label -> internal structure code.
  structures <- c(
    "data.frame (colnames)"    = "data.frame",
    "data.frame (no colnames)" = "data.frame.nocol",
    "matrix"                   = "matrix",
    "table (dimnames)"         = "table",
    "list"                     = "list"
  )
  # Multi-area selection: keep only the column-combinable structures.
  if (isTRUE(multi))
    structures <- structures[c("data.frame (colnames)",
                               "data.frame (no colnames)",
                               "list")]

  ## --- Toplevel -------------------------------------------------------------
  tt <- tcltk::tktoplevel()
  tcltk::tkwm.withdraw(tt)   # hide until fully built (avoids a blank flash)
  tcltk::tkwm.title(tt, "Excel-Data-Transfer")
  tcltk::tkwm.resizable(tt, FALSE, FALSE)
  tcltk::tkwm.iconbitmap(tt, .getImg("R.ico"))

  ## --- Tcl variables --------------------------------------------------------
  variable_var <- tcltk::tclVar("")    # variable name entry
  insert_var   <- tcltk::tclVar("0")   # "insert at cursor" checkbox (0/1)

  ## --- Input block ----------------------------------------------------------
  f <- tcltk::tkframe(tt, borderwidth = 2, relief = "groove")
  tcltk::tkpack(f, fill = "x", padx = 10, pady = c(10, 6))

  # Range address (top, highlighted).
  tcltk::tklabel(f, text = paste0("Selected Range:  ", range),
                 font = "TkDefaultFont", foreground = "navy") |>
    tcltk::tkpack(anchor = "w", padx = 5, pady = c(4, 2))

  tcltk::tklabel(f, text = "Organize data as:") |>
    tcltk::tkpack(anchor = "w", padx = 5, pady = c(0, 6))

  g <- tcltk::tkframe(f)
  tcltk::tkpack(g, anchor = "w", padx = 10, pady = c(0, 8))

  # Structure chooser.
  structure_cb <- tcltk::ttkcombobox(
    g, values = names(structures), state = "readonly", width = 25
  )
  # Default: "list" for multi-area, otherwise the first entry.
  tcltk::tkset(structure_cb,
               if (isTRUE(multi)) "list" else names(structures)[1])

  # Variable name entry.
  variable_entry <- tcltk::ttkentry(
    g, textvariable = variable_var, width = 27
  )

  # "insert at cursor" checkbox (left-aligned under the widgets, grid column 1).
  insert_cb <- tcltk::ttkcheckbutton(
    g, text = "insert data at cursor position", variable = insert_var
  )

  tcltk::tkgrid(tcltk::tklabel(g, text = "structure:"), structure_cb,
                sticky = "w", padx = 5, pady = 3)
  tcltk::tkgrid(tcltk::tklabel(g, text = "variable:"), variable_entry,
                sticky = "w", padx = 5, pady = 3)
  tcltk::tkgrid(insert_cb, column = 1, sticky = "w", padx = 5, pady = 3)

  ## --- Buttons --------------------------------------------------------------
  bf <- tcltk::tkframe(tt)
  tcltk::tkpack(bf, pady = 10)

  btn_width <- 10

  # OK: capture the three inputs into 'res' (via <<-) and close the window.
  ok_btn <- tcltk::ttkbutton(
    bf,
    text = "OK",
    width = btn_width,
    command = function() {
      res <<- list(
        structure = unname(structures[tcltk::tclvalue(tcltk::tkget(structure_cb))]),
        variable  = tcltk::tclvalue(variable_var),
        insert    = tcltk::tclvalue(insert_var) == "1"
      )
      tcltk::tkdestroy(tt)
    }
  )

  # Cancel: leave 'res' as NULL and close.
  cancel_btn <- tcltk::ttkbutton(
    bf,
    text = "Cancel",
    width = btn_width,
    command = function() tcltk::tkdestroy(tt)
  )

  tcltk::tkpack(ok_btn,     side = "left", padx = 6)
  tcltk::tkpack(cancel_btn, side = "left", padx = 6)

  ## --- Key bindings ---------------------------------------------------------
  tcltk::tkbind(tt, "<Return>", function() tcltk::tkinvoke(ok_btn))
  tcltk::tkbind(tt, "<Escape>", function() tcltk::tkdestroy(tt))

  ## --- Show window (after everything is built) ------------------------------
  tcltk::tcl("update", "idletasks")   # finish layout calculation

  # Position near the mouse cursor.
  x <- as.integer(tcltk::tclvalue(tcltk::tcl("winfo", "pointerx", ".")))
  y <- as.integer(tcltk::tclvalue(tcltk::tcl("winfo", "pointery", ".")))
  tcltk::tkwm.geometry(tt, paste0("+", x + 10, "+", y + 10))

  tcltk::tkwm.deiconify(tt)
  tcltk::tkraise(tt)
  # Force focus onto the dialog and into the variable entry, shortly after
  # deiconify so the window manager has settled.
  tcltk::tcl("after", 50, function() {
    tcltk::tcl("focus", "-force", tt)
    tcltk::tkfocus(variable_entry)
  })

  ## --- Modal ----------------------------------------------------------------
  tcltk::tkwait.window(tt)   # block until the window is destroyed

  res
}
