
#' Convert Between Centimeters and Points
#'
#' Converts numeric values between centimeters (cm) and typographic points (pt).
#' One centimeter corresponds to approximately 28.35 points.
#'
#' @param x A numeric vector.
#'
#' @details
#' The conversion is based on:
#' \deqn{1\ \mathrm{cm} \approx 28.35\ \mathrm{pt}}
#'
#' These functions are useful in graphical contexts (e.g., when specifying
#' dimensions in plotting systems).
#'
#' @name cm_pts_conversion
#' 
#' @return
#' A numeric vector of the same length as \code{x}, converted to the
#' corresponding unit.
#'
#' @examples
#' # Convert centimeters to points
#' cmToPts(1)
#'
#' # Convert points to centimeters
#' ptsToCm(28.35)
#'

#' @export
#' @rdname cm_pts_conversion
cmToPts <- function(x) x * 28.35


#' @export
#' @rdname cm_pts_conversion
ptsToCm <- function(x) x / 28.35

# http://msdn.microsoft.com/en-us/library/bb214076(v=office.12).aspx

