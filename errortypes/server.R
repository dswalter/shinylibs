library(shiny)
library(ggplot2)
library(grid)

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}





# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  

  
  output$nullplot1 <-renderPlot({
      xmin<-10
      xmax<-20
      mean<-15
      sd<-1
      decision_point<-input$decision_point
      rng<-seq(xmin,xmax,0.05)
      null_vals<-dnorm(x=rng,mean=mean,sd=sd)
      
      #null_vals<-dnorm(x=rng,mean=input$onemean,sd=input$onesdev)
      nulldf<-data.frame(x=rng,null_vals)
      nulldf$type1vals<-nulldf$null_vals
      nulldf$type1vals[nulldf$x>decision_point]<-0
      type_1_df<-subset(nulldf,x<=decision_point)
      
      nullplot<-ggplot(data=nulldf,aes(x=x))+xlim(xmin,xmax)+
        ylab("Density")+xlab("Possible Lengths")+
        ggtitle("Null Hypothesis Distribution")+
        geom_ribbon(data=nulldf,aes(ymin=0,ymax=null_vals),fill="steelblue")+
        geom_vline(x=decision_point)+
        geom_ribbon(data=type_1_df, aes(ymin=0,
                                        ymax=type1vals),fill="red")
      nullplot
  })
  
  
  output$altplot1 <-renderPlot({
    xmin<-10
    xmax<-20
    mean<-13
    sd<-1
    decision_point<-input$decision_point
    rng<-seq(xmin,xmax,0.05)
    null_vals<-dnorm(x=rng,mean=mean,sd=sd)
    
    #null_vals<-dnorm(x=rng,mean=input$onemean,sd=input$onesdev)
    nulldf<-data.frame(x=rng,null_vals)
    nulldf$type1vals<-nulldf$null_vals
    nulldf$type1vals[nulldf$x>decision_point]<-0
    type_1_df<-subset(nulldf,x<=decision_point)
    
    altplot<-ggplot(data=nulldf,aes(x=x))+xlim(xmin,xmax)+
      ylab("Density")+xlab("Possible Lengths")+
      ggtitle("Alternate Hypothesis Distribution")+
      geom_ribbon(data=nulldf,aes(ymin=0,ymax=null_vals),fill="red")+
      geom_vline(x=decision_point)+
      geom_ribbon(data=type_1_df, aes(ymin=0,
                                      ymax=type1vals),fill="steelblue")
    altplot
  })
  
  
  
})
