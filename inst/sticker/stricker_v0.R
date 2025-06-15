
# Load required libraries
library(sf)
library(ggplot2)
##library(ggforce)
library(austria)
library(data.table)



# Define Austria's flag red color
austria_red <- "#ED2939"

# Load the shape of Austria (GeoJSON or Shapefile)
austria <- get_stations() ##st_read("austria.geojson") # Replace with your actual file path

# Transform to metric projection
austria <- st_transform(austria, 3857)

# Center and scale the geometry
austria_centered <- st_geometry(austria) - st_centroid(st_union(st_geometry(austria)))
austria_scaled <- (austria_centered / max(st_bbox(austria_centered)[c("xmax", "ymax")])) * 0.8
austria_scaled <- austria_scaled |> st_coordinates() |> as.data.table()
# Create hexagon coordinates
hexagon <- data.frame(
  x = sin(seq(0, 2 * pi, length.out = 7)),
  y = cos(seq(0, 2 * pi, length.out = 7))
)

# Plot the hexagon, Austria shape, and text
gg <- ggplot() +
  geom_polygon(data = hexagon, aes(x, y), fill = "white", color = austria_red, linewidth = 2) +
##  geom_sf(data = st_sf(geometry = austria_scaled), fill = austria_red, color = NA) +
  annotate("text", x = 0, y = -1.05, label = "Austria", color = austria_red, size = 6, fontface = "bold") +
  coord_fixed() +
  theme_void()

# Save the logo
##ggsave("logo_austria_hex_text.png", width = 5, height = 5, bg = "transparent")
