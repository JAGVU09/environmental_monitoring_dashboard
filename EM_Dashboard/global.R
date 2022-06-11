library(raster)
library(png)
library(mapview)
library(leaflet)
library(terra)
library(sp)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)

micro<- read_csv('./data/micro_em.csv')

#Read in bulk manufacturing png
bulk <- readPNG('./images/Bulk Manufacturing Area.png')

bulk_img <- brick(bulk)

bulk_m <- viewRGB(bulk_img, 1, 2, 3, maxpixels =  950716)
bulk_lng = c(0.86277,0.90466,0.93624,0.17595,0.26848,0.35465,0.57198,
             0.65472,0.73505,0.436,0.54829,0.62038,0.46795,0.25354,
             0.31878,0.10265)
bulk_lat = c(0.58364,0.58364,0.58398,0.34418,0.34528,0.34268,0.48906,
             0.59668,0.59668,0.406,0.14076,0.14076,0.28204,0.25612,
             0.2768,0.2302)
bulk_labels = c("301-1","301-2","301-3","302-1","302-2","302-3","302-7",
                "304-2","304-3","305-1","311-6","311-7","312-2","314-2",
                "314-3","315-3")

#Read in aseptic air png
aseptic_air <- readPNG('./images/Asceptic Fill Suite Air.png')

aseptic_air_img <- brick(aseptic_air)

aseptic_air_m <- viewRGB(aseptic_air_img, 1, 2, 3, maxpixels =  1117363)

#Read in aseptic surface
aseptic_surf <- readPNG('./images/Asceptic Fill Suite Surface.png')

aseptic_surf_img <- brick(aseptic_surf)

aseptic_surf_m <- viewRGB(aseptic_surf_img, 1, 2, 3, maxpixels =  1117363)



#I think these actually need to go on the server side. 
site_total_count<-micro %>% 
  group_by(sample_site) %>% 
  summarise(tot_ids = n()) %>% 
  ungroup() %>% 
  arrange(desc(tot_ids))


sites<-micro$sample_site %>% unique()
