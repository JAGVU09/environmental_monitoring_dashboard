library(raster)
library(png)
library(mapview)
library(leaflet)
library(terra)
library(sp)
library(tidyr)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)

micro<- read_csv('./data/micro_em.csv')

#Read in bulk manufacturing png
bulk <- readPNG('./images/Bulk Manufacturing Area.png')

bulk_img <- brick(bulk)

bulk_m <- viewRGB(bulk_img, 1, 2, 3, maxpixels =  950716)

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
