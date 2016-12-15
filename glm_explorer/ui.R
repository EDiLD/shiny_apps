7
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage("Explore Generalized Linear Models",
  tabPanel("Introduction",
           withMathJax(),
           includeMarkdown("introduction.md")
  ),
  tabPanel("App",
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(condition="input.conditionedPanels==1",
          h3('Simulated data'),
          selectInput("family",
                      "Family:",
                      c("Gaussian" = "gaussian",
                        "Poisson" = "poisson",
                        "Negative binomial" = "negbin"),
                      "gaussian",
                      FALSE
          ),
          selectInput("link",
                      "Link function:",
                      c("identity" = "identity",
                        "log" = "log"),
                      "identity",
                      FALSE
          ),
          sliderInput("n",
                      "Number of observations:",
                      min = 10,
                      max = 1000,
                      value = 200,
                      step = 10),
          sliderInput("a",
                      "Intercept (a):",
                      min = -3,
                      max = 3,
                      value = 0,
                      step = 0.5),
          sliderInput("b_x",
                      "x (slope):",
                      min = -2,
                      max = 2,
                      value = 0,
                      step = 0.5),
          sliderInput("b_fac",
                      "fac (Group difference):",
                      min = -2,
                      max = 2,
                      value = 0,
                      step = 0.5),
          sliderInput("b_int",
                      "x:fac (Interaction between x and fac):",
                      min = -3,
                      max = 3,
                      value = 0,
                      step = 0.5),
          sliderInput("sigma",
                      "Sigma (only Gaussian):",
                      min = 0,
                      max = 3,
                      value = 0.4,
                      step = 0.1),
          sliderInput("dispersion",
                      "Theta (only Negative Binomial):",
                      min = 0,
                      max = 3,
                      value = 1.5,
                      step = 0.5)
        ),
        conditionalPanel(condition = "input.conditionedPanels==2",
          h3('Fitted model'),
          selectInput("family_mod",
                      "Family:",
                      c("Gaussian" = "gaussian",
                        "Poisson" = "poisson",
                        "Negative binomial" = "negbin"),
                      "gaussian",
                      FALSE),
          selectInput("link_mod",
                      "Link function:",
                      c("identity" = "identity",
                        "log" = "log"),
                      "identity",
                      FALSE),
          selectInput("terms_mod",
                      "Model formula:",
                      c("y~1" = "intercept",
                        "y~x" = "x",
                        "y~fac" = "fac",
                        "y~x + fac" = "both",
                        "y~x + fac + x:fac" = "interaction"),
                      "intercept",
                      FALSE),
          checkboxInput("show_pred", "Show prediction bands?", FALSE)
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Simulate", value = 1,
                   plotOutput("Plot_model")
                   # , verbatimTextOutput("range_warn")
          ),
          tabPanel("Model", value = 2,
                   plotOutput("Plot_model2"),
                   verbatimTextOutput("model_char")
          ),
          tabPanel("Model Summary", value = 2,
                   verbatimTextOutput("Summary")
          ),
          tabPanel("Model Coefficients", value = 2,
                   plotOutput("Plot_coefs")
          ),
          tabPanel("Model Diagnostics", value = 2,
                   plotOutput("Plot_diag"),
                   plotOutput("Plot_dharma")
          ),
          id = "conditionedPanels"
        )
      )
    )
  ),
  tabPanel("Exercises",
           includeMarkdown("exercises.md")
  )
))
