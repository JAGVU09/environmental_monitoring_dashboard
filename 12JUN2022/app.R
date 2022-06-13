library(leaflet)
library(shiny)
micro <- read_csv('./micro_em.csv')
bulk <- readPNG('./Bulk Manufacturing Area.png')

bulk_img <- brick(bulk)

bulk_m <- viewRGB(bulk_img, 1, 2, 3, maxpixels =  950716)
weeks <- micro %>%
  mutate(Week = week(date)) %>%
  group_by(sample_site, Week) %>%
  summarise(tot_ids = n()) %>%
  ungroup() %>%
  arrange(desc(tot_ids))
myData <- data.frame(
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
ui <- fluidPage(leafletOutput("map"),
                p(),
                plotOutput("myPlot"))
server <- shinyServer(function(input, output) {
  data <- reactiveValues(clickedMarker = NULL)
  # produce the basic leaflet map with single marker
  output$map <- renderLeaflet(
    bulk_m@map %>%
      addTiles() %>%
      addCircleMarkers(
        lat = myData$lat,
        lng = myData$lng,
        layerId = myData$id,
        popup = myData$id
      )
  )
})
# observe the marker click info and print to console when it is changed.
observeEvent(input$map_marker_click, {
  print("observed map_marker_click")
  data$clickedMarker <- input$map_marker_click
  print(data$clickedMarker)
  output$myPlot <- renderPlot({
    return(
      weeks %>%
        filter(str_detect(
          sample_site, input$map_marker_click$id
        )) %>%
        ggplot(aes(x = Week, y = tot_ids)) +
        geom_line(show.legend = FALSE) +
        geom_hline(
          yintercept = c(75, 50),
          linetype = c('solid', 'dashed'),
          color = c('red', 'orange')
        )
    )
  })
})
shinyApp(ui, server)