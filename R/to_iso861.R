NULL
#' Convert a POSIXct object to an ISO 8601 timestamp string
#'
#' This function transforms a POSIXct object into a datetime (timestamptz) ISO 8601 string.
#'
#' @param x A POSIXct object.
#' @param tz Logical. If \code{TRUE}, include the time zone information in the output string.
#' @param format used by \code{\link{format}}. See this function's default. 
#' @return A character vector of ISO 8601 timestamp strings.
#' 
#' @export
#' @examples
#' x <- as.POSIXct(c("2021-01-01 00:00:00", "2021-01-01 01:00:00", "2021-01-01 02:00:00"), tz = "UTC")
#' to_iso8601(x)
#' to_iso8601(x, tz = TRUE)
#' 
#' x <- as.POSIXct(c("2021-01-01 00:00:00", "2021-01-01 01:00:00", "2021-01-01 02:00:00"), tz = "Etc/GMT-1")
#' to_iso8601(x)
#' to_iso8601(x, tz = TRUE)
#' 
#' to_iso8601(x, tz = "toUTC") ## string with corresponding datetime in UTC.
#' 
#'
to_iso8601 <- function(x, tz = TRUE,format="%Y-%m-%dT%H:%M:%S") {
  if (tz=="toUTC") {
    x <- as.POSIXct(x,tz="UTC")
    tz=FALSE
    
  }
 
 
  if (tz) {
    return(format(x,paste0(format,"%z")))
  } else {
    return(format(x,format))
  }
}