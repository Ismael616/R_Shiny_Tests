## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title='Exercice 2'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data",
               menuSubItem('Summary',tabName = "summary"),
               menuSubItem('Raw Data',tabName = "raw")),
      menuItem("Vizualisation",icon =icon("dashboard"), tabName ="vizu")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "summary",
              h4('resumé statistique'),
              verbatimTextOutput("summ")
      ),
      tabItem(tabName = "raw",
              h4('Valeurs du dataset'),
              dataTableOutput('table1')
      ),
      tabItem(tabName ="vizu",
              h4('tab de vizualisation'),
              fluidRow(
                column(width=3,wellPanel(sliderInput("bins",
                                                     "Number of bins:",
                                                     min = 1,
                                                     max = 50,
                                                     value = 30),
                                         colourInput(inputId="col",
                                                     label='Choose color for histogram',
                                                     "#00FF0080",
                                                     allowTransparent = TRUE,
                                                     closeOnClick = TRUE),
                                         textInput('histext',label='entrer le titre de l\'histogramme',value = 'Default Hist name'),
                                         
                                         radioButtons('radio1',label='chose column for distribution plot ',
                                                      choices=colnames(faithful))
                                         
                )
                ),
                column(width = 9,tabsetPanel(type='tab',
                                             tabPanel("Histogram",plotOutput("distPlot"),h4(textOutput('nobins'),align='center'),
                                                      downloadButton('downhist',label='Download')),
                                             tabPanel("Boxplot", plotOutput('box'))
                )
                )
              )
      )
    )
  )
)

server <- function(input, output) { 
  output$summ <- renderPrint({
    summary(faithful)})
  output$table1<-renderDataTable(
    {
      faithful
    }
  )
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[,input$radio1]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = input$col, border = 'white',
         main=input$histext)
    
  })
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
  output$box<-renderPlot(
    {
      boxplot(faithful[,input$radio1],
              col=input$col,main=paste('Boxplot of',input$radio1),
              horizontal=TRUE)
    }
  )
}

shinyApp(ui, server)
