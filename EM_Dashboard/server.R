


library(shiny)
library(shinyWidgets)

shinyServer(function(input, output, session) {
  output$mymap <- renderLeaflet({
    if (input$Facility == 'Aseptic Fill Suite - Air') {
      aseptic_air_m@map
    }
    else if (input$Facility == 'Aseptic Fill Suite - Surface') {
      aseptic_surf_m@map
    }
    else {
      bulk_m@map %>%
        addTiles(options = tileOptions(minZoom = 10, maxZoom = 11)) %>%
        addCircles(lng = 0.17595, lat = 0.34418, radius = 1400)
    }
  })
})
