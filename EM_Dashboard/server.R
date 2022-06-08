


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
      bulk_m@map
    }
  })
})
