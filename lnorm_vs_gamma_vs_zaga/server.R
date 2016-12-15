

library(shiny)
library(gamlss)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    # input to objects
    mu <- input$mu
    sigma <- input$sigma
    nu <- input$nu
    
    # transform parameters
    meanlog    = log(mu^2 / sqrt(sigma^2 + mu^2))
    sdlog = sqrt(log((sigma^2 / mu^2) + 1))
    
    shape = 1 / sigma^2
    scale = mu / shape
    
    # plot density
    curve(dlnorm(x, meanlog = meanlog, sdlog = sdlog) , 0, 4, ylab = 'density')
    curve(dgamma(x, scale = scale, shape = shape), 0, 4, 
          col = 'red', add = TRUE)
    curve(dZAGA(x, mu = mu, sigma = sigma, nu = nu), 0, 4,
          col = 'blue', add = TRUE)
    legend('topright', legend = c('lognormal', 'Gamma', 'ZAGA'), lty = 1, col = c('black', 'red', 'blue'))
    
  })
  
})
