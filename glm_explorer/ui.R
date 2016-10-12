
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage("Explore Generalized Linear Models",
  tabPanel("Introduction",
           includeMarkdown("introduction.md")
  ),
  tabPanel("Model fitting",
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(condition="input.conditionedPanels==1",
          h3('Simulated data'),
          selectInput("family",
                      "Family:",
                      c("gaussian" = "gaussian",
                        "poisson" = "poisson",
                        "negative binomial" = "negbin"),
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
                      min = -5,
                      max = 5,
                      value = 0,
                      step = 0.5),
          sliderInput("b_x",
                      "slope (b_x):",
                      min = -5,
                      max = 5,
                      value = 0,
                      step = 0.5),
          sliderInput("b_fac",
                      "Group difference (b_fac):",
                      min = -5,
                      max = 5,
                      value = 0,
                      step = 0.5),
          sliderInput("b_int",
                      "Interaction (b_int):",
                      min = -5,
                      max = 5,
                      value = 0,
                      step = 0.5),
          sliderInput("sigma",
                      "Sigma (only gaussian):",
                      min = 0,
                      max = 3,
                      value = 0.4,
                      step = 0.2),
          sliderInput("dispersion",
                      "Dispersion (only negbin):",
                      min = 0,
                      max = 6,
                      value = 2,
                      step = 0.5)
        ),
        conditionalPanel(condition = "input.conditionedPanels==2",
          h3('Fitted model'),
          selectInput("family_mod",
                      "Family:",
                      c("gaussian" = "gaussian",
                        "poisson" = "poisson",
                        "negative binomial" = "negbin"),
                      "gaussian",
                      FALSE),
          selectInput("link_mod",
                      "Link function:",
                      c("identity" = "identity",
                        "log" = "log"),
                      "identity",
                      FALSE),
          selectInput("terms_mod",
                      "Terms fitted:",
                      c("intercept" = "intercept",
                        "x" = "x",
                        "fac" = "fac",
                        "both" = "both",
                        "interaction" = "interaction"),
                      "intercept",
                      FALSE)
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Data", value = 1,
                   plotOutput("Plot_model")
          ),
          tabPanel("Model", value = 2,
                   plotOutput("Plot_model2")
          ),
          tabPanel("Summary", value = 2,
                   verbatimTextOutput("Summary")
          ),
          tabPanel("Coefficients", value = 2,
                   plotOutput("Plot_coefs")
          ),
          tabPanel("Diagnostics", value = 2,
                   plotOutput("Plot_diag")
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
