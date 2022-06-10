


library(shiny)
library(shinyWidgets)

shinyServer(function(input, output, session) {
  output$mymap <- renderLeaflet({
    if (input$Facility == 'Aseptic Fill Suite - Air') {
      aseptic_air_m@map%>% 
        addTiles() %>%
        addCircles(lng = 0.08635, lat = 0.32595, radius = 2000, color = "#ff0033")
    }
    else if (input$Facility == 'Aseptic Fill Suite - Surface') {
      aseptic_surf_m@map
    }
    else {
      bulk_m@map %>% 
        addTiles(options = tileOptions(minZoom = 10, maxZoom = 11)) %>%
        addCircles(lng = lng, lat = lat, radius = 1400, color = "#ff0033")
    }
  })
})
