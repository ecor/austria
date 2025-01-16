####

library(terra)
library(sf)
library(lubridate)
library(austria)
## ELEVATION (DEM 25m) 

elev_kw <- "/home/ecor/local/rpackages/rendena100/austria/inst/ext_data/elevation/elev_kw_025m.tif" |> rast()


###plet(vect(v),alpha=0.8,tiles="OpenTopoMap",fill=FALSE)

## Alternative Usage: timestaps as POSIXct object
start_timestamp=as.POSIXct("2023-01-01",tz="Etc/GMT-1")
end_timestamp=start_timestamp+lubridate::days(2)
out <- get_inca_ts(ext=elev_kw,start_timestamp=start_timestamp,end_timestamp=end_timestamp)



outrr <- get_inca_ts(ext=elev_kw,start_timestamp=start_timestamp,end_timestamp=end_timestamp,variable="RR")

###
inca_elev <- "/home/ecor/local/rpackages/rendena100/austria/inst/ext_data/elevation/INCA_DEM.nc" |> rast()
project(inca_elev,y="epsg:3857",method="near") |> plet(tile="OpenTopoMap",alpha=0.5)

### AS SF OBJECT 

###as.data.table(inca_kw_elev,xy=TRUE) |> st_as_sf(coords=c("x","y"))




inca_kw_elev <- crop(inca_elev,out)
project(inca_kw_elev,y="epsg:3857",method="near") |> plet(tile="OpenTopoMap",alpha=0.5)

### AS SF OBJECT 

inca_kw_elev_sf <- as.data.table(inca_kw_elev,xy=TRUE) |> st_as_sf(coords=c("x","y"),crs=crs(inca_elev))
names(inca_kw_elev_sf)[1] <- "inca_elev"
inca_kw_elev_sf$icell_inca <- 1:nrow(inca_kw_elev_sf)



inca_kw_elev_sf <- inca_kw_elev_sf |> st_transform(crs=crs(elev_kw))

inca_kw_elev_sf$icell <- cellFromXY(elev_kw,st_coordinates(inca_kw_elev_sf))
inas <- which(is.na(inca_kw_elev_sf$icell))
inca_kw_elev_sf <- inca_kw_elev_sf[-inas,]

inca_kw_elev_sf$elev <- elev_kw[as.vector(inca_kw_elev_sf$icell)]

inca_kw_elev_sf$diff_elev <-  inca_kw_elev_sf$inca_elev-inca_kw_elev_sf$elev

summary(inca_kw_elev_sf)

ii <- which(abs(inca_kw_elev_sf$diff_elev)<=10)


inca_kw_elev_sf2 <- inca_kw_elev_sf[ii,]

inca_kw_elev_sf2
plet(vect(inca_kw_elev_sf2))


# inca_kw_elev_sf3 <- inca_kw_elev_sf2 |> st_transform(crs=4326)
# 
# inca_kw_elev_sf3$newcode <- sprintf("INCAKW%04d",1:nrow(inca_kw_elev_sf3))

###  GET 1 variable 
area_kw <- "/mnt/e1/local/simulations/lwf_bavaria/area_lwf/studyarea_kw.shp" |> st_read() |>
  st_transform(crs=st_crs(inca_kw_elev_sf2))


area_kw_b2 <- area_kw |>st_buffer(dist=10000)
area_kw_b1 <- area_kw |>st_buffer(dist=5000)
area_kw_b0 <- area_kw |>st_buffer(dist=3500)
inca_kw_elev_sf3 <- inca_kw_elev_sf2 |> st_crop(y=area_kw_b0)
ppB <- inca_kw_elev_sf3
### selected point A 
ppA <- inca_kw_elev_sf3[140,] ## inca_kw_elev_sf3 <- inca_kw_elev_sf2 |> st_crop(y=area_kw_b0)
### selected point B1,B2,B3
ppBs <- inca_kw_elev_sf3[115:116,]
write_karwendel <- TRUE
if (write_karwendel) {
  pps <- inca_kw_elev_sf3[c(140,115:117),]
  pps$name=c("A","B1","B2","B3")
  pps <- pps %>% select(geometry,name,elev)
  pps <- pps %>% st_transform(crs=4326)
  pps_shp <- "/home/ecor/local/rpackages/rendena100/austria/inst/ext_data/karwendel_inca_1km_points.shp"

st_write(pps,dsn=pps_shp,delete_layer=TRUE)

}
