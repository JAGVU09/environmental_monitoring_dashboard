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

#read in the data and clean it up for analysis
micro<-read_excel('./data/eMIC Notebook - Berg.xlsx', col_types = c('Site_location' = 'text')) %>% 
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
  str_trunc(.,6, ellipsis = '',side = c('right')) %>% 
  str_replace('Air', '') %>% 
  str_replace('-\\s+', '-') %>% 
  str_squish %>% 
  str_replace('-$', '') %>% 
  str_replace('^[A-Za-z]+[\\s?|\\S?].[A-Za-z]*\\W\\d?\\W?|^0\\d+\\S\\w|\\d+mL|\\d% Cre', '') %>% 
  str_replace('^[A-Za-z]+', '') %>%
  str_replace('P|Run|[$]|10 mL|Dil|-Bac|-Fin|-che|-Che|\\d-Mi|-Sle|1-Lab|<62> T|-bac', '') %>% 
  str_replace('^[-]', '') %>% 
  str_replace(' ', '') %>% 
  str_replace('108-\\d*\\w*|110-\\d*\\w*', "")

micro$sample_site[micro$sample_site==""]<-NA

micro<- micro %>% drop_na()

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
