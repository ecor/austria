
# Carica i pacchetti necessari
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
##library(ggforce)
library(austria)
library(data.table)

#
# Author; Emanuele Cordano
# Date: 2020-08-13
#
library(hexSticker)
library(png)
library(magrittr)
library(purrr)
library(lubridate)
library(terra)
library(tidyterra)
library(RColorBrewer)
imgurl <- system.file("figures/cat.png", package="hexSticker")
imggeotop <- '/home/ecor/Dropbox/inst/sticker/logo/logo_geotop.png'


#v <- system.file("ext_data/bbox_kw_area.shp",package="austria")
#v <- v |> st_read()
v <- austria <- ne_countries(scale = "medium", country = "Austria", returnclass = "sv")
start_timestamp=as.POSIXct("2024-02-01",tz="Etc/GMT-1")
end_timestamp=start_timestamp+lubridate::days(1)

url_variables_snowgrid <- "https://dataset.api.hub.geosphere.at/v1/grid/historical/snowgrid_cl-v2-1d-1km/metadata/parameters"

variables_snow <- get_variables(url_variables_snowgrid)[2]



##
###url_snowgrid_template='https://dataset.api.hub.geosphere.at/v1/grid/historical/snowgrid_cl-v2-1d-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&lat_lon=LAT2N%2CLON2E&lat_lon=LAT1S%2CLON1W&output_format=csv'
url_snowgrid_template='https://dataset.api.hub.geosphere.at/v1/grid/historical/snowgrid_cl-v2-1d-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&bbox=LAT1S%2CLON1W%2CLAT2N%2CLON2E&output_format=netcdf'
austria_snow <- get_inca_ts(url=url_snowgrid_template,variable=variables_snow$name,
                        ext=v,start_timestamp=start_timestamp,end_timestamp=end_timestamp)
## END Usage with SNOWGRID dataset 


#filesticker <- '/home/ecor/Dropbox/R-packages/geotopbricks/inst/sticker/sticker_geotopbricks_v2_prov_.png'
#f#ilesticker3 <- '/home/ecor/Dropbox/R-packages/geotopbricks/inst/sticker/sticker_geotopbricks_v2_.png'
##filesticker3_jpg  <- '/home/ecor/Dropbox/R-packages/geotopbricks/inst/sticker/sticker_geotopbricks_v2_.jpg'


filesticker3_jpg  <- '/home/ecor/local/rpackages/rendena100/austria/inst/sticker/sticker_austria.jpg'

# Define Austria's flag red color
austria_red <- "#ED2939"
italia_red <-  "#CE2B37" 
france_red <-  "#EF4135" 
# Load the shape of Austria (GeoJSON or Shapefile)
austria <- get_stations() ##st_read("austria.geojson") # Replace with your actual file path

# Transform to metric projection
austria <- st_transform(austria, 3857)
##austria <- austria |> st_coordinates() |> as.data.table()

palette <- brewer.pal(9, "YlGnBu")


#palette <- brewer.pal(9, "PRGn") |> rev()

# Definisci una palette policromatica interpolata
palette <- colorRampPalette(c(
  "#00008B", # Dark Blue
  "#0000FF", # Blue
  "#00BFFF",  # Deep Sky Blue
  "#00FFFF",  # Cyan
  "#7FFFD4",  # Aquamarine
  "#ADFF2F",  # Green Yellow
  "#FFFF00",  # Yellow
  "#FFA500",  # Orange
  "#FF4500",  # Orange Red
  "#FF0000",  # Red
  austria_red,
  "#8B0000",   # Dark Red
  "#999999"
 
))(100) |> rev()
###

library(ggplot2)
##p <- ggplot(aes(x = X, y = Y), data = austria) + geom_point()
p <- ggplot()+geom_spatraster(data=log(austria_snow+1)) 
p <- p + geom_sf(data=austria,size=0.1,col="black")
p <- p + scale_fill_gradientn(colors = palette, na.value = "transparent")

p <- p + theme_void() + theme_transparent()+theme(legend.position = "none")
outfile <- filesticker3_jpg ##tempfile(fileext=".png")



ll <- list(p, package="austria", filename=outfile,
        h_fill="white",
        h_color=austria_red,
        p_color=austria_red,p_size=22,
        s_width=0.8*2.3,
        s_height=0.6*2.3,
        s_x=1,s_y=0.95,p_y=1.5)


do.call(what=sticker,args=ll)

lp <- ll
raster::extension(lp$filename) <- "png" 
do.call(what=sticker,args=lp)

