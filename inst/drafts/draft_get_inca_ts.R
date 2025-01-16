NULL
#'
#'
#'
#'
#'
#'
#'
#'
#'
# https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=RR%2CT2M&start=2021-01-01T00%3A00&end=2021-01-01T00%3A00&bbox=47.45%2C14.05%2C47.50%2C14.10&output_format=geojson
# get_inca_ts <- function(u,
#                         variable=(get_variables()$name),lat=NA,lon=NA,size=0.1,latsize=size,lonsize=size,
#                         lat2n=lat+latsize/2,lat1s=lat-latsize/2,
#                         lon2e=lon+lonsize/2,lon1w=lon-lonsize/2, 
#                         start_timestamp,
#                         end_timestamp)        
#                         
#                         )








https://dataset.api.hub.geosphere.at/v1/timeseries/historical/inca-v1-1h-1km?parameters=VARIABLES&start=2021-01-01T00%3A00&end=2021-01-01T00%3A00&lat_lon=48.206248%2C16.367569&lat_lon=47.262886%2C11.394676&output_format=csv

https://dataset.api.hub.geosphere.at/v1/timeseries/historical/inca-v1-1h-1km?parameters=VARIABLES&start=START_TIMESTAMP%3A00&end=END_TIMESTAMP%3A00&lat_lon=LAT2N%2CLON2E&lat_lon=LAT1S%2CLON1W&output_format=csv

https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=RR%2CT2M&start=2021-01-01T00%3A00&end=2021-01-01T00%3A00&bbox=47.45%2C14.05%2C47.50%2C14.10&output_format=geojson




https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=RR&start=2021-01-01T00%3A00&end=2021-01-01T00%3A00&bbox=47.45%2C14.05%2C47.50%2C14.10&output_format=netcdf



u <- GET("https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=RR,P0&start=2021-01-01T00%3A00&end=2022-01-01T00%3A00&bbox=47.45%2C14.05%2C47.50%2C14.10&output_format=netcdf")
writeBin(content(u, "raw"), "/home/ecor/local/rpackages/rendena100/austria/inst/output.nc")
Response [https://dataset.api.hub.geosphere.at/v1/grid/historical/inca-v1-1h-1km?parameters=RR&start=2021-01-01T00%3A00&end=2021-01-01T00%3A00&bbox=47.45%2C14.05%2C47.50%2C14.10&output_format=netcdf]
Date: 2024-12-09 16:08
Status: 200
Content-Type: application/x-netcdf
Size: 37.4 kB
<BINARY BODY>
  > 