NULL
#' Get available datasets
#'
#'
#' @param url dafault is \url{https://dataset.api.hub.geosphere.at/v1/datasets}
#' @param json logical Returns a json object 
#' @param ... further arguments 
#' 
#' 
#' @export
#' 
#' @importFrom jsonlite fromJSON
#'
#' 
#' @examples
#'
#' 
#' out <- get_datasets()
#' library(stringr)
#'## SEARCH snowgrid 
#'###/grid/historical/snowgrid_cl-v2-1d-1km
#' nn <- names(out)[str_detect(names(out),"snowgrid")]
#' 
#' 



#https://dataset.api.hub.geosphere.at/v1/openapi-docs#/all%20datasets/View_and_filter_all_available_datasets_datasets_get
###SNOWGRID : https://public.hub.geosphere.at/public/datahub.html?id=snowgrid_cl-v2-1d-1km/filelisting&prefix=/snow_depth/


get_datasets <- function(url='https://dataset.api.hub.geosphere.at/v1/datasets',json=TRUE,...) {
  
  
  
  out <- GET(url)
  if (json) out <- out |> as.character() |> fromJSON()
  return(out)
  
}