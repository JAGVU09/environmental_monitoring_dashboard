
library(shiny)

shinyServer(function(input, output, session) {
  output$mymap <- renderLeaflet({
    m@map
  })
})
