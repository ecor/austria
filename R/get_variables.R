NULL
#'
#' Gets weather variable names / parameters from Geoshere APIs 
#'
#' @param url API variables coreesponding to GeoShere API parameters. See default
#'
#'
#'
#' @seealso \url{https://dataset.api.hub.geosphere.at/v1/openapi-docs},\url{https://dataset.api.hub.geosphere.at/v1/docs/},
#' \url{https://dataset.api.hub.geosphere.at/v1/openapi-docs#/historical/Historical_Grid_Parameter_Metadata_CSV_grid_historical__resource_id__metadata_parameters_get}
#' 
#' 
#' @importFrom httr GET
#' 
#' @export
#
#'
#'
#' @examples
#' 
#' 
#' variables <- get_variables()
#' 
#  \url{https://dataset.api.hub.geosphere.at/v1/docs/}
  ## \url{https://dataset.api.hub.geosphere.at/v1/openapi-docs#/timeseries/Historical_Timeseries_timeseries_historical__resource_id__get}
     # 
   
   
   
get_variables <- function(url="https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km/metadata/parameters") {
  
  out <- GET(url) |> csv_to_dt()
  
  return(out)
  
  
}