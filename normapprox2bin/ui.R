library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hello Shiny!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      sliderInput("n",
                  "Number of Experiments:",
                  min = 1,
                  max = 1000,
                  value = 30),
      sliderInput("p",
                  "Probability of Success:",
                  min = 0.001,
                  max = 0.999,
                  value = 0.5)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      plotOutput("normbinPlot")
    )
  )
))
