library(shiny)
library(vegan)
data(pyrifos)
time <- gl(11, 12, labels=c(-4, -1, 0.1, 1, 2, 4, 8, 12, 15, 19, 24))
treatment <- factor(rep(c(0.1, 0, 0, 0.9, 0, 44, 6, 0.1, 44, 0.9, 0, 6), 11))
replicate <- gl(12, 1, length=132)
envdata <- data.frame(replicate, treatment, time)


shinyServer(function(input, output){
  abu <- reactive({
      abufile <- input$abufile
      if (input$example == TRUE & is.null(abufile)) {
        pyrifos
      } else {
        if (input$example == FALSE & !is.null(abufile)) {
          read.csv(
            file = abufile$datapath,
            header = input$header,
            sep = input$sep,
            quote = input$quote
            )
        }	
      }
      })

  env <- reactive({
    envfile <- input$envfile
    if (input$example == TRUE & is.null(envfile)) {
      envdata
    } else {
      if (input$example == FALSE & !is.null(envfile)) {
        read.csv(
          file = envfile$datapath,
          header = input$header,
          sep = input$sep,
          quote = input$quote
        )
      }  
    }
  })
  
  
  output$abutable <- renderTable({
    abu()[1:10 , 1:10]
    })
  
  output$envtable <- renderTable({
    env()[1:10, ]
  })
})
