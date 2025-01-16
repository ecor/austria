NULL
#'
#' It redirects and write weather time series to GEOtop Hydrological Model Simulation
#' 
#' @param x object (weather time series} returned by \code{\link{get_ts}} or \code{\link{get_inca_ts}}(wide table)
#' 
#' 
#' @export
#' 
#' 
#' 
#' @example 
#' ## TO DO 
#' 
#' library(geotopbricks)
#' wpath <- "/home/ecor/local/rpackages/rendena100/austria/inst/ext_data/
#' karwendel <- 
#' xy <- st_coordinates(karwendel)
#' ## Point 1 
#' end2_timestamp=start_timestamp+lubridate::years(1)
#' outkw <- get_inca_ts(lon=xy[1,1],lat=xy[1,2],size=0.005,start_timestamp=start_timestamp,end_timestamp=end2_timestamp,return_data_table=TRUE) ###,variable="RR")
#' 
#' 
to_geotop <- function(x,wpath,level,
                      headers =list(
                        HeaderIPrec = "R1", ## mm data must be exclusively hourly
                        HeaderWindVelocity = "F", ##WindSp" m/s 
                        HeaderWindDirection = "D",## WindDir" deg north ?
                        HeaderWindX = "UU",
                        HeaderWindY = "VV",
                        HeaderRH = "RH2M"
                        HeaderAirTemp = "T2M",
                        HeaderAirPress = "P0", ## hPa AirP"
                        HeaderSWglobal =  "GL", 
                       
                      ),
                      unit =list(
                        HeaderIPrec = 1,#"R1", ## mm data must be exclusively hourly
                        HeaderWindVelocity = 1,#"F", ##WindSp" m/s 
                        HeaderWindDirection = 1,#"D",## WindDir" deg north ?
                        HeaderWindX = 1, #"WindX",
                        HeaderWindY = 1,"WindY",
                        HeaderRH =1, ### "RF_TU", ###"RelHum"
                        HeaderAirTemp =1, ## "TT_TU",
                        HeaderAirPress =1, "P0", ## hPa AirP"
                        HeaderSWglobal =1
                      ),
                      offset=list(
                        HeaderIPrec = 0,
                        HeaderWindVelocity = 0,
                        HeaderWindDirection = 0,
                        HeaderWindX = 0,
                        HeaderWindY = 0,
                        HeaderRH = 0,
                        HeaderAirTemp =0,
                        HeaderAirPress =0,
                        HeaderSWglobal =0,
                      
                      ),
                      write_geotop_meteo_file=FALSE,
                      geotop_meteo_file_keyword="MeteoFile"
                      
                      
                      
                      ,...) {
  
  
  out <- NULL
  
  
  return(out)
  
  
  
}