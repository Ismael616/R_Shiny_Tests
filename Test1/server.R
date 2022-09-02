#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tmap)
#install.packages("rAmCharts")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderAmCharts({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[,input$radio1]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    amHist(x, breaks = bins, col = input$col, border = 'white',
         main=input$histext)
    
  })
  output$summary <- renderPrint({
    summary(faithful)})
  output$table1<-renderDataTable(
    {
      faithful
    }
  )
  output$nobins <-renderText(
    {
      paste('le nombre de bins est : ',input$bins)
    }
  )
  output$downhist<-downloadHandler(
    filename=function(){
      paste('hist','.png')
    },
    content=function(file)
    {
      png(file)
      hist(faithful[,input$radio1]
           , breaks = seq(min(x), max(x), length.out = input$bins + 1),
           col = input$col, border = 'white',
           main=input$histext)
      dev.off()
      
    }
  )
  output$box<-renderAmCharts(
    {
      amBoxplot(faithful[,input$radio1],
              col=input$col,main=paste('Boxplot of',input$radio1),
              horiz=TRUE)
    }
  )
  output$map<-renderTmap(
    { data("World")
      tm_shape(World)+
        tm_polygons("economy")+tm_layout(bg.color = input$col,inner.margins = c(0, .02, .02, .02))
    }
  )
  output$line <- renderPlotly(
    {
      plot_ly(x = faithful[,input$lineselect[1]],y = faithful[,input$lineselect[2]], type = 'scatter',mode = 'markers',
              marker=list(size=5,color=input$col))
    })
})

