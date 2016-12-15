
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Log-Normal vs Gamma vs Zero-adjusted Gamma"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("mu",
                   "mu:",
                   min = 0.5,
                   max = 2,
                   value = 2,
                   step = 0.1),
       sliderInput("sigma",
                   "sigma:",
                   min = 0,
                   max = 1,
                   value = 0.5,
                   step = 0.1),
       sliderInput("nu",
                   "nu:",
                   min = 0,
                   max = 1,
                   value = 0,
                   step = 0.1)
    ),
    
    # Show a plot of the density functions
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
