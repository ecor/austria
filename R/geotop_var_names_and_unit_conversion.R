NULL
#'
#' List with header keyword for GEOtop weather variables and the correspondance of AT-INCA variables
#' 
#' @param headers GEOtop variable keyword and their correspondence with INCA-AT ones
#' @param unit unit/scale  factor between Geotop unit and INCA AT unit. 
#' @param offset offset between Geotop unit and INCA AT unit. 
#' @param ... further arguments
#' 
#' 
#' @export
#' 
#' @seealso \code{\link{get_ts}} (internal code) 
#' 
#' @examples 
#' 
#' 
#' out <- geotop_var_names_and_unit_conversion()
#' 
#' 
#' 
#' 
geotop_var_names_and_unit_conversion <- function(
                      headers =list(
                        HeaderIPrec = "RR", ## mm data must be exclusively hourly
                        HeaderWindVelocity = "F", ##WindSp" m/s 
                        HeaderWindDirection = "D",## WindDir" deg north ?
                        HeaderWindX = "UU",
                        HeaderWindY = "VV",
                        HeaderRH = "RH2M",
                        HeaderAirTemp = "T2M",
                        HeaderAirPress = "P", ## hPa AirP"
                        HeaderSWglobal =  "GL"
                       
                      ),
                      unit =list(
                        HeaderIPrec = 1,#"R1", ## mm data must be exclusively hourly
                        HeaderWindVelocity = 1,#"F", ##WindSp" m/s 
                        HeaderWindDirection = 1,#"D",## WindDir" deg north ?
                        HeaderWindX = 1, #"WindX",
                        HeaderWindY = 1,"WindY",
                        HeaderRH =1, ### "RF_TU", ###"RelHum"
                        HeaderAirTemp =1, ## "TT_TU",
                        HeaderAirPress =1/100, "P", ## hPa AirP"
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
                        HeaderSWglobal =0
                      
                      ),
                      ...){


        out <- list(headers=headers,unit=unit,offset=offset,...)


        return(out)
}
                      
#                       
#                       ,
#                       write_geotop_meteo_file=FALSE,
#                       geotop_meteo_file_keyword="MeteoFile"
#                       
#                       
#                       
#                       ,...) {
#   
#   
#   out <- NULL
#   
#   
#   return(out)
#   
#   
#   
# }