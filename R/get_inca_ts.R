NULL
#' 
#' Gets inca time series from historical stations
#'
#' @param url_template template of the URL used 
#' @param ...,tz arguments passed to \code{\link{get_ts}}
#' @param ncfilename filename assigned to the downloaded netCDF file  (optional) 
#' @param return_rast logical. If \code{TRUE} default and \code{ncfilename} is not \code{NULL} and a proper charactr string, function returns a \code{\link{SpatRaster-class}} object. 
#' @param return_data_table logical. Default is \code{FALSE}.It is used in case a one-pixel netCDF file translating the cell of the pixel into a virtual measurement point. 
#' @param wide_table logical. If \code{TRUE} and only one node is extracted, time series is returned as a wide table. Default is \code{FALSE}. 
#' @param as_geotop logical. Mute argument , not used currently
#' @importFrom httr content
#' @importFrom terra rast
#' @importFrom data.table as.data.table dcast
#' @importFrom dplyr select
#' 
#' @importFrom stringr str_sub str_split 
#' @importFrom rlang .data
#' @importFrom stats time 
#' @importFrom terra time<-
#' 
#' @export
#' @seealso \url{https://dataset.api.hub.geosphere.at/v1/openapi-docs#/grid/Historical_Grid_Data_grid_historical__resource_id__get}
#' @return a connection or a spatio-temporal raster object or a data table. 
#' 
#' 
#' library(terra)
#' library(sf)
#' v <- system.file("ext_data/bbox_kw_area.shp",package="austria")
#' v <- v |> st_read()
#'
#' plet(vect(v),alpha=0.8,tiles="OpenTopoMap",fill=FALSE)

#' start_timestamp=as.POSIXct("2023-01-01",tz="Etc/GMT-1")
#' end_timestamp=start_timestamp+lubridate::days(2)
#' out <- get_inca_ts(ext=v,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
#'
#' ###ncfilename <- "/home/ecor/local/rpackages/rendena100/austria_materials/netcdf/rr.nc"
#' start_timestamp=as.POSIXct("2023-01-01",tz="Etc/GMT-1")
#' end_timestamp=start_timestamp+lubridate::days(62)
#' outrr <- get_inca_ts(ext=v,start_timestamp=start_timestamp,end_timestamp=end_timestamp,variable="RR")
#'
#' #### 
#' karwendel <- "/home/ecor/local/rpackages/rendena100/austria/inst/ext_data/karwendel_inca_1km_points.shp" |> st_read()
#' xy <- st_coordinates(karwendel)
#' ## Point 1 
#' end2_timestamp=start_timestamp+lubridate::years(1)
#' outkw <- get_inca_ts(lon=xy[1,1],lat=xy[1,2],size=0.005,start_timestamp=start_timestamp,end_timestamp=end2_timestamp,return_data_table=TRUE) ###,variable="RR")
#' 
#'
#'
#' wpath <- "/home/ecor/local/rpackages/rendena100/austria/inst/kw_meteo_template"
#' outkw2 <- get_inca_ts(wpath=wpath,level=8,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp,return_data_table=TRUE,wide_table=TRUE)
#' outkw2_ts <- get_ts(wpath=wpath,level=8,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
#' 
#'
#







### https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=RR&start=2021-01-01T00%3A00&end=2021-02-01T00%3A00&bbox=47.45%2C14.05%2C47.50%2C14.10&output_format=netcdf






get_inca_ts <- function (url_template="https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&bbox=LAT1S%2CLON1W%2CLAT2N%2CLON2E&output_format=netcdf",
                         ...,ncfilename=paste0(tempfile(),".nc"),return_rast=TRUE,return_data_table=FALSE,wide_table=FALSE,tz = "Etc/GMT-1",as_geotop=FALSE) {
  
  
  
  out <- get_ts(url_template=url_template,...,tz=tz,return_data_table=FALSE,as_geotop=FALSE)
  url <- attr(out,"url")
  cond <- is.character(ncfilename)
  if (cond) {
    cond <- !cond
    if (str_sub(ncfilename,start=-3)==".nc") cond <- TRUE
    
    
  }
  
  if (cond) {
    print(ncfilename)
    writeBin(content(out, "raw"),ncfilename)
    
    ######
    if (return_rast | return_data_table) out <- rast(ncfilename)
    terra::time(out) <- as.POSIXct(terra::time(out),tz=tz)
    if (return_data_table) {
      
      #####out <- as.data.frame(out,xy=TRUE,cells=TRUE)
      out <- as.data.frame(out,xy=TRUE,wide=FALSE,time=TRUE,cells=TRUE) |> as.data.table()
      out$variable <- str_split(out$layer,"_") |> sapply(FUN=function(x){x[1]})
     
      if (length(unique(out$icell)!=1)) long_table <- FALSE  
      if (wide_table) {
       
        out <- out |> select(.data$time,.data$values,.data$variable) 
      
        
        out <- out |> dcast(time ~ variable,value.var="values")
       
      }
      
    }
    ######
  }
    
  attr(out,"url") <- url
  return(out)
  
  
}  
####url_template='https://dataset.api.hub.geosphere.at/v1/timeseries/historical/inca-v1-1h-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&lat_lon=LAT2N%2CLON2E&lat_lon=LAT1S%2CLON1W&output_format=csv',