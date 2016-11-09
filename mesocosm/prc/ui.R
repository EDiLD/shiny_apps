#runApp('C:\\Users\\pbuttigi\\Documents\\Revolution\\EATME\\RDA', launch.browser = FALSE)

library(shiny)
library(markdown)

shinyUI(
  navbarPage("PRC",
             tabPanel('Data'),
             sidebarLayout(
                sidebarPanel(
                  tabsetPanel(
                    tabPanel("Example data", 
                            h4("Use example data"),
                            p("Tick the box below if you'd like to use the chlorpyrifos' dataset:"),
                            checkboxInput('example', 'Use Chlorpyrifos dataset', FALSE),
                            h4("Download example data"),
                            p("Alternatively, you can download both data files here and upload them in the next tab.")
                            ),
                    tabPanel("Data Upload",
                              h3("Upload data in csv format"),
                              h4("CSV settings:"),
                              h5(strong("Header")),
                              checkboxInput('header', 'first row contains column names', TRUE),
                              radioButtons(
                                inputId = 'sep',
                                label = 'Separator',
                                choices = c(
                                  Comma = ',',
                                  Semicolon = ';',
                                  Tab = '\t'
                                  )
                                ),
                              radioButtons(
                                inputId = 'quote',
                                label = 'Quotes',
                                choices = c(
                                  'Double quotes' = '"',
                                  'Single quotes' = "'",
                                  'None' = ''
                                )
                              ), 
                            h5(strong("Abundance data")),
                            fileInput(
                              inputId = 'abufile', 
                              label = 'Select a CSV file with samples as rows and species as columns.',
                              accept = c('text/csv','text/comma-separated-values','.csv')
                            ),
                            h5(strong("Explanatory data")),
                            fileInput(
                              'envfile', 
                              'Select a CSV file with three columns: time, treatment and replicat. ',
                              accept = c('text/csv','text/comma-separated-values','.csv')
                              )
                            )
                    )
                  ),
                mainPanel(
                  h3("Abundance data"),
                  p("Displaying first 10 species, and rows"),
                  tableOutput("abutable"),
                  h3("Env data"),
                  p("Displaying first 10 rows"),
                  tableOutput("envtable")
                  ),
                ),
             tabPanel('Transformations'),
             tabPanel('Plot'),
             tabPanel('Summary'),
             tabPanel('Population level statistics')
             ))
