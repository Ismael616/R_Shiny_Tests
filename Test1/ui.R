#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(colourpicker)
library(rAmCharts)
library(tmap)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(navbarPage(
  
  # Application title
  title='Exercice 3',
  tabPanel('Data',
           navlistPanel('navigation list',
                        tabPanel("Summary", "summary du dataset",
                                 verbatimTextOutput("summary")),
                        tabPanel("Data", "donées brutes",
                                 dataTableOutput('table1')))),
  tabPanel('Vizualisation',
           fluidRow(
             column(width=3,wellPanel(sliderInput("bins",
                                                  "Number of bins:",
                                                  min = 1,
                                                  max = 50,
                                                  value = 30),
                                      # selectInput(inputId = "color", label = "Couleur :",
                                      #choices = c("Rouge" = "red", "Vert" = "green", "Bleu" = "blue")),
                                      colourInput(inputId="col",
                                                  label='Choose color for histogram',
                                                  "#00FF0080",
                                                  allowTransparent = TRUE,
                                                  closeOnClick = TRUE),
                                      textInput('histext',label='entrer le titre de l\'histogramme',value = 'Default Hist name'),
                                      radioButtons('radio1',label='chose column for distribution plot ',
                                                   choices=colnames(faithful)),
                                      selectizeInput('lineselect', label='select features for line plot',
                                                     choices=colnames(faithful), selected =NULL, multiple = TRUE,
                                                     options =list(maxItems=2)))), # colonne 1/4 (3/12)
             column(width = 9,tabsetPanel(type='tab',
                                          tabPanel("line", plotlyOutput('line')),
                                          tabPanel("Histogram",amChartsOutput("distPlot"),h4(textOutput('nobins'),align='center'),
                                                   downloadButton('downhist',label='Download')),
                                          tabPanel("Boxplot", amChartsOutput('box')),
                                          tabPanel("Map", tmapOutput('map',width='100%'))
             ),
             ) # colonne 3/4 (9/12)
           ))
))
