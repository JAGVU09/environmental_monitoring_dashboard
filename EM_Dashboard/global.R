library(raster)
library(png)
library(mapview)
library(leaflet)
library(terra)
library(rgdal)

png <- readPNG('./images/Bulk Manufacturing Area.png')

rst_blue <- raster(png[, , 1])
rst_green <- raster(png[, , 2])
rst_red <- raster(png[, , 3])

img <- brick(rst_red, rst_green, rst_blue)

m <- viewRGB(img, maxpixels =  950716)

