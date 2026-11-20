NULL
#' 
#' Gets time series from historical stations
#'
#' @param url_template template of the URL used 
#' @param variable variables/parameterts of whch time series is requested. See default.
#' @param lat,lon geograghical latitude and logitude of the place where time series is/are requested. 
#' @param size,latsize,lonsize size of the lat/lon spatial extentwhere time series is/are requested.
#' @param lat1s,lat2n,lon1w,lon2e lat/lon extent parameters
#' @param ext lat/lon extent , it is used in case one of \code{lat1s,lat2n,lon1w,lon1e} is \code{NA} 
#' @param crs  crs/srid default is \code{4326}.  
#' @param variable_code character string in \code{url_template} that will be replaced forfor  "VARIABLES"
#' @param start_timestamp_code character string in \code{url_template} that will be replaced for "START_TIMESTAMP"
#' @param end_timestamp_code character string in \code{url_template} that will be replaced for "END_TIMESTAMP"
#' @param lat2n_code   character string in \code{url_template} that will be replaced for "LAT2N"
#' @param lat1s_code   character string in \code{url_template} that will be replaced for "LAT1S"
#' @param lon2e_code   character string in \code{url_template} that will be replaced for "LON2E"
#' @param lon1w_code   character string in \code{url_template} that will be replaced for "LON1W"
#' @param start_timestamp,end_timestamp initial and final timestamps. See examples  
#' @param tz time zone 
#' @param return_POSIXct logical. If \code{TRUE} output timstamp is returned as POSIXct (\code{\link{as.POSIXct}}),otherwise if \code{FALSE} a character string. 
#' @param format used by \code{\link{to_iso8601}}. See this function's default. 
#' @param return_data_table logical. Default is \code{TRUE}. 
#' @param remove_duplicates logical argument 
#' @param write_geotop_meteo_file logical. If \code{TRUE} GEOtop meteo file is written. See Default.
#' @param geotop_meteo_file_keyword GEOtop keywords with filename prefix of the GEOtop meteo file. See Default.
#' @param wpath path to the directory of GEOtop simulation (optional)
#' @param geotop_meteo_lon_keyword,geotop_meteo_lat_keyword character GEOtop keywords of Meteo Station latitude and logitude. See default. 
#' @param level number of the meteorological station. It is used in case \code{use_geotop==TRUE} and \code{lat,lon} are directly not set.
#' @param use_geotop logical argument. If \code{TRUE} function uses \code{GEOtop} model set-up to retrieve latitude and longitude information about the weather station.
#' @param as_geotop  logical argument. If \code{TRUE} outcomes are \code{zoo} objects as for GEOtop
#' @param vars_headers list retured by  \code{\link{geotop_var_names_and_unit_conversion}} (see there mfor more details)
#' 
#' @importFrom stringr str_replace_all
#' @importFrom sf st_bbox st_transform
#' @importFrom geotopbricks get.geotop.inpts.keyword.value
#' @importFrom zoo as.zoo index<- 
#' @importFrom geotopbricks create.geotop.meteo.files
#' @export
#' @seealso \code{\link{get_stations}},\code{\link{get_variables}},\code{\link{geotop_var_names_and_unit_conversion}},\url{https://dataset.api.hub.geosphere.at/v1/openapi-docs#/timeseries/Historical_Timeseries_timeseries_historical__resource_id__get}
#'
#' @examples
#' 
#' ## Basic usage
#' ## SeeFeld,Tyrol coordinates
#' ## https://en.wikipedia.org/wiki/Seefeld_in_Tirol
#' lat=47.329444
#' lon=11.189167
#' lats=lat+0.1*c(-1,1)
#' lons=lon+0.1*c(-1,1)
#' start_timestamp="2021-01-01T00"
#' end_timestamp <- "2022-01-01T00"
#'
#' ts <- get_ts(lat=lat,lon=lon,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
#' 
#' 
#'
#' ## Usage with SNOWGRID dataset 
#' url_variables_snowgrid <- "https://dataset.api.hub.geosphere.at/v1/grid/historical/snowgrid_cl-v2-1d-1km/metadata/parameters"
#' variables_snow <- get_variables(url_variables_snowgrid)
#' 
#' 
#' url_snowgrid_template='https://dataset.api.hub.geosphere.at/v1/timeseries/historical/snowgrid_cl-v2-1d-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&lat_lon=LAT2N%2CLON2E&lat_lon=LAT1S%2CLON1W&output_format=csv'
#' snow_ts <- get_ts(url=url_snowgrid_template,variable=variables_snow$name,
#' lat=lat,lon=lon,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
#' ## END Usage with SNOWGRID dataset 
#' 
#' 
#' 
#' ## Alternative Usage: timestaps as POSIXct object
#' start_timestamp=as.POSIXct("2022-01-01",tz="Etc/GMT-1")
#' end_timestamp=start_timestamp+lubridate::years(1)
#'
#' ts2 <- get_ts(lat=lat,lon=lon,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
#' if (nrow(ts2)>0) print("Function get_ts works")
#'
#'
#'
#' ## Usage with GEOtop
#'
#' wpath <- "/home/ecor/local/rpackages/rendena100/austria/inst/kw_meteo_template"
#' ts3 <- get_ts(wpath=wpath,level=8,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
#'
#' ## Write GEOtop files
#' 
#' 
#' 
#' kw_ts <- list() 
#' levels <- 10:20
#' for (level in levels) {
#'   kw_ts[[level]] <- get_ts(wpath=wpath,level=level,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp,as_geotop=TRUE,write_geotop_meteo_file=TRUE)
#' }
#'

get_ts <- function(url_template='https://dataset.api.hub.geosphere.at/v1/timeseries/historical/inca-v1-1h-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&lat_lon=LAT2N%2CLON2E&lat_lon=LAT1S%2CLON1W&output_format=csv',
   variable=(get_variables()$name),lat=NA,lon=NA,size=0.1,latsize=size,lonsize=size,
   lat2n=lat+latsize/2,lat1s=lat-latsize/2,
   lon2e=lon+lonsize/2,lon1w=lon-lonsize/2, crs=4326,ext,
   start_timestamp,
   end_timestamp,
   variable_code="VARIABLES",
   start_timestamp_code="START_TIMESTAMP",
   end_timestamp_code="END_TIMESTAMP",
   lat2n_code="LAT2N",
   lat1s_code="LAT1S",
   lon2e_code="LON2E",
   lon1w_code="LON1W",
   tz="Etc/GMT-1",
   format="%Y-%m-%dT%H",
   return_POSIXct=TRUE,
   return_data_table=TRUE,
   remove_duplicates=TRUE,
   use_geotop=FALSE,
   wpath=NULL,
   geotop_meteo_lon_keyword="MeteoStationLongitude",
   geotop_meteo_lat_keyword="MeteoStationLatitude",
   write_geotop_meteo_file=FALSE,
   geotop_meteo_file_keyword="MeteoFile",
   level=1,
   as_geotop=write_geotop_meteo_file,
   vars_headers=geotop_var_names_and_unit_conversion()
   )
  {
  
  
  print(start_timestamp)
  print(end_timestamp)
  # u_url <- 'https://dataset.api.hub.geosphere.at/v1/timeseries/historical/inca-v1-1h-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=2021-12-01T00%3A00&lat_lon=LAT2N%2CLON2E&lat_lon=LAT1S%2CLON1W&output_format=csv' |> 
  #   str_replace_all("VARIABLES",variable) |> 
  #   str_replace_all("START_TIMESTAMP",start_timestamp) |>
  #   str_replace_all("END_TIMESTAMP",end_timestamp) |> 
  #   str_replace_all("LAT2N",lat2n) |> 
  #   str_replace_all("LAT1S",lat1s) |> 
  #   str_replace_all("LON2E",lon2e) |>
  #   str_replece_all("LON1E",lon1e)
  
  if (!is.character(start_timestamp)) start_timestamp <- to_iso8601(start_timestamp,tz="toUTC",format=format)
  if (!is.character(end_timestamp)) end_timestamp <- to_iso8601(end_timestamp,tz="toUTC",format=format)
  
  if (use_geotop) {
    
    ### 
    lat <- geotop_meteo_lat_keyword |> get.geotop.inpts.keyword.value(wpath=wpath,numeric=TRUE)
    lon <- geotop_meteo_lon_keyword |> get.geotop.inpts.keyword.value(wpath=wpath,numeric=TRUE)
    ###
    print(lat)
    print(lon)
    lat <- lat[level]
    lon <- lon[level]
    ###
    print(level)
    print(lat)
    print(lon)
    lonsize=latsize=0.01/1000
    lat2n=lat+latsize/2
    lat1s=lat-latsize/2
    lon2e=lon+lonsize/2
    lon1w=lon-lonsize/2
    
    
  }
  
  if (any(is.na(c(lat1s,lat2n,lon1w,lon2e)))) {
    
    ext <- st_bbox(ext) |> st_transform(crs=crs)
    lat1s <- ext$ymin
    lat2n <- ext$ymax
    lon1w <- ext$xmin
    lon2e <- ext$xmax
    
  }
  print(start_timestamp)
  print(end_timestamp)
  if (length(variable)>1) variable <- paste(variable,collapse=",")
  u_url <- url_template |> 
    str_replace_all(variable_code,variable) |> 
    str_replace_all(start_timestamp_code,start_timestamp) |>
    str_replace_all(end_timestamp_code,end_timestamp) |> 
    str_replace_all(lat2n_code,as.character(lat2n)) |> 
    str_replace_all(lat1s_code,as.character(lat1s)) |> 
    str_replace_all(lon2e_code,as.character(lon2e)) |>
    str_replace_all(lon1w_code,as.character(lon1w))
  
   
 
  out <- GET(u_url) 
  
  if (return_data_table) {
      out <- out |> csv_to_dt()
  if (return_POSIXct) {
    
    out$time <- from_iso8601(out$time,tz=tz)
    
  }
  if (remove_duplicates) {
        
        pid <- paste(out$time,out$lat,out$lon,sep="_")
        inonduplicated <- which(!duplicated(pid))
        out <- out[inonduplicated,]
        
  }    
      
  }
  
  if (as_geotop==TRUE) {
    
    ## TO_DO
    
    nn2 <- sapply(str_split(names(out)," "),FUN=function(x){x[1]})
    names(out) <- nn2
    out2 <- as.data.frame(out)
    ngeotop <- unlist(vars_headers$headers)
    ngeotop <- ngeotop[ngeotop %in% names(out)]
    out2 <- out2[,c("time",ngeotop)]
    ##timex <- out$time 
    
    
    for (it in names(ngeotop)){
      print(it)
      nng <- vars_headers$headers[[it]]
      unit <- vars_headers$unit[[it]]
      offset <- vars_headers$offset[[it]]
      print(nng)
      itx <- it |> get.geotop.inpts.keyword.value(wpath=wpath)
      names(out2)[names(out2)==nng] <- itx
      out2[,itx] <- out2[,itx]*unit+offset
      
      
      
    }
    timex <- out2$time
    out2 <- out2[,names(out2)!="time"]
    out2 <- out2 |> as.zoo()
    index(out2) <- timex
    
    
    out <- out2
    #####
    if (write_geotop_meteo_file) {
      
      meteo <- out
      file_prefix <-  geotop_meteo_file_keyword |> get.geotop.inpts.keyword.value(wpath=wpath,add_wpath=TRUE)
      attr(out,"meteo_file") <- create.geotop.meteo.files(x=meteo,file_prefix=file_prefix,level=level) 
      
      
      
    }
    
    
    #####
  }  
    
    
    
  
  attr(out,"url") <- u_url
  
  
  return(out)
}


