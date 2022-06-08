library(raster)
library(png)
library(mapview)
library(leaflet)
library(terra)
library(rgdal)
library(tidyr)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)

#Read in bulk manufacturing png
bulk <- readPNG('./images/Bulk Manufacturing Area.png')

bulk_blue <- raster(bulk[, , 1])
bulk_green <- raster(bulk[, , 2])
bulk_red <- raster(bulk[, , 3])

bulk_img <- brick(bulk_red, bulk_green, bulk_blue)

bulk_m <- viewRGB(bulk_img, maxpixels =  950716)

#Read in aseptic air png
aseptic_air <- readPNG('./images/Asceptic Fill Suite Air.png')

aseptic_air_blue <- raster(aseptic_air[, , 1])
aseptic_air_green <- raster(aseptic_air[, , 2])
aseptic_air_red <- raster(aseptic_air[, , 3])

aseptic_air_img <- brick(aseptic_air_red, aseptic_air_green, aseptic_air_blue)

aseptic_air_m <- viewRGB(aseptic_air_img, maxpixels =  1117363)

#Read in aseptic surface
aseptic_surf <- readPNG('./images/Asceptic Fill Suite Surface.png')

aseptic_surf_blue <- raster(aseptic_surf[, , 1])
aseptic_surf_green <- raster(aseptic_surf[, , 2])
aseptic_surf_red <- raster(aseptic_surf[, , 3])

aseptic_surf_img <- brick(aseptic_surf_red, aseptic_surf_green, aseptic_surf_blue)

aseptic_surf_m <- viewRGB(aseptic_surf_img, maxpixels =  1117363)

#read in the data and clean it up for analysis
micro<-read_excel('./data/eMIC Notebook - Berg.xlsx') %>% 
  fill(`MID Number`, .direction = "down") %>% 
  fill(`Colony Morphology`, .direction = "down") %>% 
  fill(`Performance Date`, .direction = "down") %>% 
  pivot_longer(cols = starts_with('Site Location'), values_drop_na = TRUE) %>% 
  dplyr::select(`Performance Date`, `MID Number`, `Colony Morphology`, value) %>% 
  rename(date = `Performance Date`, ID = `MID Number`, sample_site = value) %>% 
  mutate(date = parse_date_time(`date`,orders = 'd%B%Y%')) %>% 
  mutate(Q = quarter(`date`, with_year = TRUE))

#REGEX to clean up the sample sites
micro$sample_site<-micro$sample_site %>%
  str_replace('\\d+[:|-]\\s?\\d+:?\\s?:?[A-Za-z]+\\s?\\d+', '\\d+-\\d+') %>%
  str_replace('-\\s+', '-')

#I think these actually need to go on the server side. 
site_total_count<-micro %>% 
  group_by(sample_site) %>% 
  summarise(tot_ids = n()) %>% 
  ungroup() %>% 
  arrange(desc(tot_ids))

site_q_count<-micro %>% 
  group_by(sample_site, Q) %>% 
  summarise(tot_ids = n()) %>% 
  ungroup() %>% 
  arrange(desc(tot_ids))

sites<-micro$sample_site %>% unique()
