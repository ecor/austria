
# Load required libraries
library(sf)
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

imgurl <- system.file("figures/cat.png", package="hexSticker")
imggeotop <- '/home/ecor/Dropbox/inst/sticker/logo/logo_geotop.png'

##

#filesticker <- '/home/ecor/Dropbox/R-packages/geotopbricks/inst/sticker/sticker_geotopbricks_v2_prov_.png'
#f#ilesticker3 <- '/home/ecor/Dropbox/R-packages/geotopbricks/inst/sticker/sticker_geotopbricks_v2_.png'
##filesticker3_jpg  <- '/home/ecor/Dropbox/R-packages/geotopbricks/inst/sticker/sticker_geotopbricks_v2_.jpg'


filesticker3_jpg  <- '/home/ecor/local/rpackages/rendena100/austria/inst/sticker/sticker_austria.jpg'

# Define Austria's flag red color
austria_red <- "#ED2939"

# Load the shape of Austria (GeoJSON or Shapefile)
austria <- get_stations() ##st_read("austria.geojson") # Replace with your actual file path

# Transform to metric projection
austria <- st_transform(austria, 3857)
##austria <- austria |> st_coordinates() |> as.data.table()

library(ggplot2)
##p <- ggplot(aes(x = X, y = Y), data = austria) + geom_point()
p <- ggplot() + geom_sf(data=austria,size=0.5)
p <- p + theme_void() + theme_transparent()
outfile <- filesticker3_jpg ##tempfile(fileext=".png")
sticker(p, package="austRia", filename=outfile,
        h_fill="white",
        h_color=austria_red,
        p_color=austria_red,p_size=22,
        s_width=0.8*2.2,
        s_height=0.6*2.2,
        s_x=1)



