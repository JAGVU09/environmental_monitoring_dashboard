



library(shiny)
library(shinyWidgets)

shinyServer(function(input, output, session) {
  output$mymap <- renderLeaflet({
    if (input$Facility == 'Aseptic Fill Suite - Air') {
      aseptic_air_m@map %>%
        addTiles() %>%
        addCircles(
          lng = 0.08635,
          lat = 0.32595,
          radius = 2000,
          color = "#ff0033"
        )
    }
    else if (input$Facility == 'Aseptic Fill Suite - Surface') {
      aseptic_surf_m@map
    }
    else {
      bulk_m@map %>%
        addTiles() %>%
        addCircles(
          lng = bulk_lng,
          lat = bulk_lat,
          radius = 1400,
          color = "#ff0033",
          weight = 2,
          label = bulk_labels,
          group = 'room',
          popup = popupGraph(graphs, width = 400, height = 300)
        )
    }
  })
  output$graph <- renderPrint({
    input$map_marker_click
  })
  
  output$tim <- renderPlot({
    graph <-
      df %>% filter(str_detect(sample_site == input$map_marker_click$label))
    print(
      ggplot(data = temp, aes(x = Week, y = tot_ids)) +
        geom_line(show.legend = FALSE) +
        geom_hline(
          yintercept = c(75, 50),
          linetype = c('solid', 'dashed'),
          color = c('red', 'orange')
        )
    )
  })
})
