#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  rst_blue <- raster(png[, , 1])
  rst_green <- raster(png[, , 2])
  rst_red <- raster(png[, , 3])
  
  img <- brick(rst_red, rst_green, rst_blue)
  
  m <- viewRGB(img)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addMarkers(lng = ohs$x, lat = ohs$y)
  })
})

