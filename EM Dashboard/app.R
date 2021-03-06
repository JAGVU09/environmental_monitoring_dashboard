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
library(leafem)
library(leafpop)
library(shiny)
library(tseries)
library(forecast)
library(shinythemes)
#Read in the data
micro <- read_csv('./micro_em.csv') %>%
  mutate(Week = week(date)) %>%
  group_by(sample_site, Week) %>%
  summarise(tot_ids = n()) %>%
  ungroup() %>%
  arrange((Week))
#create raster layer for the Bulk Manufacturing Area
bulk <- readPNG('./Bulk Manufacturing Area.png')

bulk_img <- brick(bulk)

bulk_m <- viewRGB(bulk_img, 1, 2, 3, maxpixels =  950716)
#create raster layer for the  aseptic air png
aseptic_air <- readPNG('./Asceptic Fill Suite Air.png')

aseptic_air_img <- brick(aseptic_air)

aseptic_air_m <-
  viewRGB(aseptic_air_img, 1, 2, 3, maxpixels =  1117363)

#create raster layer for the aseptic surface
aseptic_surf <- readPNG('./Asceptic Fill Suite Surface.png')

aseptic_surf_img <- brick(aseptic_surf)

aseptic_surf_m <-
  viewRGB(aseptic_surf_img, 1, 2, 3, maxpixels =  1117363)
bulk_Data <- data.frame(
  lat = c(
    0.58364,
    0.58364,
    0.58398,
    0.34418,
    0.34528,
    0.34268,
    0.48906,
    0.59668,
    0.59668,
    0.406,
    0.14076,
    0.14076,
    0.28204,
    0.25612,
    0.2768,
    0.2302
  ),
  lng = c(
    0.86277,
    0.90466,
    0.93624,
    0.17595,
    0.26848,
    0.35465,
    0.57198,
    0.65472,
    0.73505,
    0.436,
    0.54829,
    0.62038,
    0.46795,
    0.25354,
    0.31878,
    0.10265
  ),
  id = c(
    "301-1",
    "301-2",
    "301-3",
    "302-1",
    "302-2",
    "302-3",
    "302-7",
    "304-2",
    "304-3",
    "305-1",
    "311-6",
    "311-7",
    "312-2",
    "314-2",
    "314-3",
    "315-3"
  )
)
ui <- navbarPage(
  'Environmental Monitoring',
  collapsible = TRUE,
  theme = shinytheme('slate'),
  tabPanel(
    'About',
    fluidPage(
      'Environmental Monitoring Application:',
      p(),
      'Use this app to visualize the microbial data
                                    from a pharmaceutical clean room environment.',
      p(),
      'Click on the sampling sites to visualize data for that site.
                                    Results are total counts grouped by weeks.',
      p(),
      'Click on Forecasting to see predictions
                                    based on historical data for each site. 
      Use this data to make informed decisions on disinfectants and cleaning routines.'
    )
  ),
  tabPanel('Facility Maps',
           fluidPage(
             theme = shinytheme('slate'),
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   "Facility",
                   "Bulk Manufacturing Area & Aseptic Fill Suite",
                   choices = c(
                     'Bulk Manufacturing Area',
                     'Aseptic Fill Suite - Air',
                     'Aseptic Fill Suite - Surface'
                   )
                 )
               ),
               mainPanel(leafletOutput("map"),
                         p(),
                         plotOutput("myPlot"),
                         p(), )
             )
           )),
  tabPanel('Forecasting',
           fluidPage(theme = shinytheme('slate'),
                     plotOutput('arima')))
)
server <- shinyServer(function(input, output) {
  data <- reactiveValues(clickedMarker = NULL)
  # produce the basic leaflet map with single marker
  output$map <- renderLeaflet({
    if (input$Facility == 'Aseptic Fill Suite - Air') {
      aseptic_air_m@map %>%
        addTiles(options = tileOptions(minZoom = 10 , maxZoom = 13)) %>%
        addCircles(
          lng = 0.08635,
          lat = 0.32595,
          radius = 2000,
          color = "#ff0033"
        )
    }
    else if (input$Facility == 'Aseptic Fill Suite - Surface') {
      aseptic_surf_m@map %>%
        addTiles(options = tileOptions(minZoom = 10 , maxZoom = 13))
    }
    else {
      bulk_m@map %>% #addRasterRGB(x = bulk_img, map=bulk_m@map) %>% 
        addTiles(options = tileOptions(minZoom = 10 , maxZoom = 13)) %>%
        addCircleMarkers(lat = bulk_Data$lat,
                         lng = bulk_Data$lng,
                         layerId = bulk_Data$id)
    }
  })
  # observe the marker click info and print to console when it is changed.
  observeEvent(input$map_marker_click, {
    print("observed map_marker_click")
    data$clickedMarker <- input$map_marker_click
    print(data$clickedMarker)
    
    output$myPlot <- renderPlot({
      micro %>%
        filter(str_detect(sample_site, paste0(data$clickedMarker$id[[1]], '\\b'))) %>%
        ggplot(aes(x = Week, y = tot_ids, color = sample_site)) +
        geom_line() +
        geom_hline(
          yintercept = c(75, 50),
          linetype = c('solid', 'dashed'),
          color = c('red', 'orange')
        ) +
        labs(x = "Week", y = "CFU", title = "Viable Count") +
        annotate('text',
                 x = 5,
                 y = 52,
                 label = 'Alert Level') +
        annotate('text',
                 x = 5,
                 y = 77,
                 label = 'Action Level')
    })
    output$arima <- renderPlot({
     #browser()
      micro %>%
        filter(str_detect(sample_site, paste0(data$clickedMarker$id[[1]], '\\b'))) %>%
        dplyr::select(tot_ids) %>% ts(frequency = 52) %>%
        auto.arima(lambda = 'auto') %>% 
        forecast(h = 10)  %>%
        plot(
          xlab = 'Weeks',
          ylab = 'CFU',
          main = paste0(data$clickedMarker$id[[1]])
          )
    })
  })
})
shinyApp(ui, server)