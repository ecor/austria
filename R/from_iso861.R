NULL
#' Convert an ISO 8601 timestamp string to a POSIXct object
#'
#' This function transforms a datetime (timestamptz) ISO 8601 string into a POSIXct object.
#' @param x timestamp ISO 8601 string
#' @param tz_included tz logical . If \code{TRUE} time zone info is included in the last 6 characters of \code{x}
#' @param tz,... srguments for \code{\link{as.POSIXct}}
#'
#' \url{https://en.wikipedia.org/wiki/ISO_8601}
#' 
#' @export
#' @importFrom stringr str_sub str_split
#' @importFrom lubridate ymd_hm seconds
#' 
#' @seealso \code{\link{ymd_hm}}
#' @examples
#' 
#' x <- c("2021-01-01T00:00+00:00","2021-01-01T01:00+00:00","2021-01-01T02:00+00:00")
#' 
#' from_iso8601(x)
#' from_iso8601(x, tz_included = TRUE, tz = "Europe/Rome")
#' from_iso8601(x, tz_included = TRUE, tz = "America/New_York")
#' 
#' 

from_iso8601 <- function(x,tz_included=TRUE,tz="Etc/GMT-1",...) {
  
  
  
  
  #####
  
  
  #####
  if (tz_included) { 
    out <- str_sub(x,end=-7)
    tzm <- str_sub(x,start=-6) |> str_split(":") |> 
      lapply(function(x){(as.numeric(x) %*% c(3600,60)) |> as.numeric()}) |>
      unlist()
  } else {
    out <- x
    tzm <- 0
    
  }
  out <- ymd_hm(out,tz="UTC")-seconds(tzm)
  out <- as.POSIXct(out,tz=tz,...)
###  attr(out,"tz") <- tzm
  return(out)
  
  
}







