
library(shiny)
library(shinyWidgets)

# Define UI
shinyUI(fluidPage(
  titlePanel("Clean Room Environmental Monitoring"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Facility",
                 "Bulk Manufacturing Area & Aseptic Fill Suite",
                 choices = c('Bulk Manufacturing Area',
                             'Aseptic Fill Suite - Air',
                             'Aseptic Fill Suite - Surface')
                 
      )
    ),
    mainPanel(
      tabsetPanel(type = 'tabs',
                  tabPanel('Map', leafletOutput("mymap"),
                           p()),
                  tabPanel('Column', plotOutput("column", height = "600px"))
      )
    )
  )
)
)