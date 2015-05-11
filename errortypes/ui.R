library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Type 1 and Type 2 Errors"),
  
  # Sidebar with a slider input for the number of bins
    # Show a plot of the generated distribution
    mainPanel(
      
      p("When performing a hypothesis test, there are a number of possible outcomes
        based on our null and alternative hypotheses."),
      p("Let's say we know absolutely that the null hypothesis is true. This would, of course, 
        make the hypothesis test completely unnecessary. But let's think this through. If $H_0$ 
        is true, and evaluating our data, we reject the null, we have concluded incorrectly. We call this a 
        'type 1 error.' It is also known as '$\alpha$' or 'significance level.' But if $H_0$ is 
        true and we fail to reject the null (FTR for short), then we have made the correct decision."),
      p("On the other hand, if we know absolutely $H_a$ is true, then if we reject the null, 
        we have come to the correct conclusion. We call this 'power.' But if $H_a$ is true and 
        we fail to reject the null, we have again concluded incorrectly. But this is the 
        opposite type of mistake. We call incorrectly failing to reject the null a 'type 2 
        error,' or '$\beta$.' Because power and $\beta$ are the only possible outcomes if the
        H_a is true, by rules of probability, power + $\beta$ = 1."),
      p("Let's look at an example."),
      h4("Bolts"),
      sliderInput("decision_point",
                  "Choose the decision line:",
                  value = 14,
                  min = 12,
                  max = 15,
                  step = 0.05),
      plotOutput("nullplot1"),
      plotOutput("altplot1"),
      p("More text should go here")
      )
      )
      )
