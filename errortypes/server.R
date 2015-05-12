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
  
  

  
  output$changedecision <-renderPlot({
      xmin<-10
      xmax<-20
      nullmean<-15
      sd<-1
      decision_point<-input$decision_point
      rng<-seq(xmin,xmax,0.05)
      null_vals<-dnorm(x=rng,mean=nullmean,sd=sd)
      
      #null_vals<-dnorm(x=rng,mean=input$onemean,sd=input$onesdev)
      nulldf<-data.frame(x=rng,null_vals)
      nulldf$type1vals<-nulldf$null_vals
      nulldf$type1vals[nulldf$x>decision_point]<-0
      type_1_df<-subset(nulldf,x<=decision_point)
      
      nullplot<-ggplot(data=nulldf,aes(x=x))+xlim(xmin,xmax)+
        ylab("Density")+xlab("Possible Lengths")+
        ggtitle("Probability Distribution under the Null Hypothesis")+
        geom_ribbon(data=nulldf,aes(ymin=0,ymax=null_vals),fill="#238E23")+
        geom_vline(x=decision_point)+
        geom_ribbon(data=type_1_df, aes(ymin=0,
                                        ymax=type1vals),fill="red")
      
      
      altmean<-13
      sd<-1
      decision_point<-input$decision_point
      rng<-seq(xmin,xmax,0.05)
      null_vals<-dnorm(x=rng,mean=altmean,sd=sd)
      
      #null_vals<-dnorm(x=rng,mean=input$onemean,sd=input$onesdev)
      nulldf<-data.frame(x=rng,null_vals)
      nulldf$type1vals<-nulldf$null_vals
      nulldf$type1vals[nulldf$x>decision_point]<-0
      type_1_df<-subset(nulldf,x<=decision_point)
      
      altplot<-ggplot(data=nulldf,aes(x=x))+xlim(xmin,xmax)+
        ylab("Density")+xlab("Possible Lengths")+
        ggtitle("Probability Distribution under the Alternate Hypothesis")+
        geom_ribbon(data=nulldf,aes(ymin=0,ymax=null_vals),fill="#FF7F00")+
        geom_vline(x=decision_point)+
        geom_ribbon(data=type_1_df, aes(ymin=0,
                                        ymax=type1vals),fill="steelblue")
      multiplot(nullplot,altplot)
      
      
  })
  
  output$type1 <- renderText({ 
    firsttext<-"The probability of a type 1 error is the probability of incorrectly rejecting the null.
    In this case, that is concluding that the bolt is from machine B when it is really from machine A. With
    a decision point of "
    secondtext<-", that probability is the area under a Normal(15,1) curve to the left of our decision point,
    which is "
    colortext<- "This area is colored red in the plots above."
    cdfval<-round(pnorm(input$decision_point,mean=15,sd=1),3)
    paste(firsttext,input$decision_point,secondtext,cdfval,". ",colortext,sep="")
  })
  
  output$keepnull<-renderText({
    firsttext<-"Correctly failing to reject the null is the same as concluding that the bolt is from 
    machine A when it is really from machine A. With a decision point of "
    secondtext<-", that probability is the area under a Normal(15,1) curve to the right of our decision point, 
    which is "
    colortext<- "This area is colored darker green in the plots above."
    cdfval<-round(1-pnorm(input$decision_point,mean=15,sd=1),3)
    paste(firsttext,input$decision_point,secondtext,cdfval,". ",colortext,sep="")
  })
  
  output$power<-renderText({
    firsttext<-"Power is the probability of correctly rejecting the null.
    In this case, that is concluding that the bolt is from machine B when it is really from machine B. With
    a decision point of "
    secondtext<-", that probability is the area under a Normal(13,1) curve to the left of our decision point,
    which is "
    colortext<- "This area is colored blue in the plots above."
    cdfval<-round(pnorm(input$decision_point,mean=13,sd=1),3)
    paste(firsttext,input$decision_point,secondtext,cdfval,". ",colortext,sep="")
  })
  
  output$type2<-renderText({
    firsttext<-"The probability of a type 2 error is the probability of incorrectly failing to reject the null.
    In this case, that is concluding that the bolt is from machine A when it is really from machine B. With
    a decision point of "
    secondtext<-", that probability is the area under a Normal(13,1) curve to the right of our decision point,
    which is "
    colortext<- "This area is colored darker green in the plots above."
    cdfval<-round(1-pnorm(input$decision_point,mean=13,sd=1),3)
    paste(firsttext,input$decision_point,secondtext,cdfval,". ",colortext,sep="")
  })
  
  
  output$all_table<-renderTable({
    type_1<-paste("Type 1 = ",round(pnorm(input$decision_point,mean=15,sd=1),3),sep="")
    keepnull<-round(1-pnorm(input$decision_point,mean=15,sd=1),3)
    power<-paste("Power = ",round(pnorm(input$decision_point,mean=13,sd=1),3),sep="")
    type_2<-paste("Type 2 = ",round(1-pnorm(input$decision_point,mean=13,sd=1),3),sep="")
    out_matrix<-matrix(c(type_1,power,keepnull,type_2),ncol=2,nrow=2)
    rownames(out_matrix)<-c("Null is True", "Null is not True")
    colnames(out_matrix)<-c("P(Reject Null)","P(FTR Null)")
    out_matrix
  })
  
  
})
