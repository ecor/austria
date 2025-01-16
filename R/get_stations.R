NULL
#' 
#' Gets historical weather stations from from Geoshere Austria APIs 
#'
#' @param url API url. See default 
#' @param return_as_sf logical. If \code{TRUE} (default) function return a \code{sf} object
#' @param english_names logical. If \code{TRUE} column nemers are translated from German to English.
#' @param column_names_en character vector with English column names, see default.
#' @param crs  crs/srid default is \code{4326}.  
#' 
#'
#' @importFrom sf st_as_sf
#'
#' @return a \code{sf} or a \code{data.table} object 
#' 
#' @export
#' @seealso \url{https://dataset.api.hub.geosphere.at/v1/openapi-docs#/timeseries/Historical_Timeseries_timeseries_historical__resource_id__get}
#'
#' @examples
#' library(terra)
#' stations <- get_stations()
#' 
#' plet(vect(stations),col="green")
#'



get_stations <- function(url="https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v1-10min/metadata/stations",
                         return_as_sf=TRUE,
                         english_names=return_as_sf,
                         column_names_en=c("id", "number", "name", "longitude", "latitude", 
                                              "altitude", "StartDate", "EndDate", "State", "Sunshine", "GlobalRadiation"),crs=4326) {
  
  out <- out <- GET(url) |> csv_to_dt()
  if (return_as_sf) english_names=TRUE
  if (english_names) {
    
    
    names(out) <- column_names_en 
    
  }
  
  if (return_as_sf) {
    
    out <- out |> st_as_sf(coords = c("longitude", "latitude"), crs = crs)
    
  }
  
  return(out)
}