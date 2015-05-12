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
        make the hypothesis test completely unnecessary. But let's think this through. If H0 
        is true, and evaluating our data, we reject the null, we have concluded incorrectly. We call this a 
        'type 1 error.' It is also known as 'alpha' or 'significance level.' But if H0 is 
        true and we fail to reject the null (FTR for short), then we have made the correct decision."),
      p("On the other hand, if we know absolutely Ha is true, then if we reject the null, 
        we have come to the correct conclusion. We call this 'power.' But if Ha is true and 
        we fail to reject the null, we have again concluded incorrectly. But this is the 
        opposite type of mistake. We call incorrectly failing to reject the null a 'type 2 
        error,' or 'beta.' Because power and beta are the only possible outcomes if the
        Ha is true, by rules of probability, power + beta = 1."),
      p("Let's look at an example."),
      h3("Bolts"),
      p("You are in charge of two bolt-making machines at a factory. Since you have been tending to these
        machines for many years and seen hundreds of thousands of bolts come off the line, you have a pretty
        good understanding of the probability distributions of bolt width for the two machines. Machine A makes
        bolts that are normally distributed with a mean of 15 and a standard deviation of 1, or a Normal(15,1)
        distribution. Machine B makes bolts with a mean of 13 and a standard deviation of 1, or a Normal(13,1)
        distribution."),
      p("Sometimes bolts fall of the line, but the two machines are so close to one another, we can't tell
        which machine the bolt came from. So we have to decide based on length. Let's frame this in terms a 
        hypothesis test. Our null hypothesis is that the bolt came from Machine A, and the alternative
        hypothesis is that it came from machine B."),      
      plotOutput("changedecision"),
      sliderInput("decision_point",
                  "Choose the decision line:",
                  value = 13.5,
                  min = 12,
                  max = 15,
                  step = 0.05),
      h3("If the null is true..."),
      textOutput("type1"),
      textOutput("keepnull"),
      h3("If the alternative is true..."),
      textOutput("power"),
      textOutput("type2"),
      h3("In Table Form"),
      p("The table below contains the same information as the previous paragraphs, but in a different format. 
        The way to read it as follows. Each row represents a different situation. In the first row, the null
        is true, so the bolt is from machine A. The first column is then the probability of rejecting the null 
        given that the null is true. The second column is the probability of failing to reject the null when the
        null is true, etc."),
      tableOutput('all_table'),
      h3("Questions"),
      p("a. Move the decision line too see how the relative probabilities change. When you move the decision line
      closer to the mean of Machine A, watch how the probability of a type 1 error changes. Does it increase
or decrease?"),
      p("b. Find and report the decision point that puts the significance level (or probability of a type 1 error) just under
        0.05. What's the power for the test using this decision point?"),
      p("c. For our bolt problem, let's assume the two types of errors are equally bad. What decision point minimizes
        the total error percentage (calculated by adding the type 1 probability and the type 2 probability?")
      )
      )
      )
