library(mapview)
library(png)
library(raster)
library(leaflet)

ohs<-data.frame(OHS_no=c(1001:1010), x=runif(10, 0, 1), y = runif(10, 0, 0.8))
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

png <- readPNG('./images/Bulk Manufacturing Area.png')