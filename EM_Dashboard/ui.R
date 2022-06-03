
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Clean Room Environmental Monitoring"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Facility","Bulk Manufacturing Area & Aseptic Fill Suite",
                  choices = c('Bulk Manufacturing Area', 'Aseptic Fill Suite'),
                  width='150px'
      )
    ),
    mainPanel(
      tabsetPanel(type = 'tabs',
                  tabPanel('Map', leafletOutput("mymap"),
                           p()
                  )
      )
    )
  )
)
)