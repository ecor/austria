
library(austria) 

library(terra)
library(sf)
library(stringr)
v <- system.file("ext_data/bbox_kw_area.shp",package="austria")
v <- v |> st_read()

plet(vect(v),alpha=0.8,tiles="OpenTopoMap",fill=FALSE)
start_timestamp=as.POSIXct("2023-01-01",tz="Etc/GMT-1")
end_timestamp=start_timestamp+lubridate::days(2)
out <- get_inca_ts(ext=v,start_timestamp=start_timestamp,end_timestamp=end_timestamp)

###ncfilename <- "/home/ecor/local/rpackages/rendena100/austria_materials/netcdf/rr.nc"
start_timestamp=as.POSIXct("2023-01-01",tz="Etc/GMT-1")
end_timestamp=start_timestamp+lubridate::days(62)
outrr <- get_inca_ts(ext=v,start_timestamp=start_timestamp,end_timestamp=end_timestamp,variable="RR")

#### 
karwendel <- "/home/ecor/local/rpackages/rendena100/austria/inst/ext_data/karwendel_inca_1km_points.shp" |> st_read()
xy <- st_coordinates(karwendel)
## Point 1 
end2_timestamp=start_timestamp+lubridate::years(1)
outkw <- get_inca_ts(lon=xy[1,1],lat=xy[1,2],size=0.005,start_timestamp=start_timestamp,end_timestamp=end2_timestamp,return_data_table=TRUE) ###,variable="RR")



wpath <- "/home/ecor/local/rpackages/rendena100/austria/inst/kw_meteo_template"

level <- 10

start_timestamp=as.POSIXct("2005-01-01",tz="Etc/GMT-1")
end_timestamp=start_timestamp+lubridate::years(20)
start_timestamp=start_timestamp+lubridate::years(10)
end_timestamp=start_timestamp+lubridate::days(31)
cc <- system.time({
  outkw2 <- get_inca_ts(wpath=wpath,level=level,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp,return_data_table=TRUE,wide_table=TRUE)
})

cc_ts <- system.time({
  outkw2_ts <- get_ts(wpath=wpath,level=level,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
})
outkw2a_ts <- outkw2_ts
nn2 <- sapply(str_split(names(outkw2_ts)," "),FUN=function(x){x[1]})
names(outkw2_ts) <- nn2            
nn2 <- names(outkw2)
nn2 <- nn2[nn2!="time"]

outkw_check <- outkw2[, ..nn2]-outkw2_ts[,..nn2]

summary(outkw_check)




### END OF THE EXAMPLE 


  

outkw3_ts <- list() 
levels <- 10:20
for (level in levels) {
  outkw3_ts[[level]] <- get_ts(wpath=wpath,level=level,use_geotop=TRUE,start_timestamp=start_timestamp,end_timestamp=end_timestamp,as_geotop=TRUE,write_geotop_meteo_file=TRUE)
}

