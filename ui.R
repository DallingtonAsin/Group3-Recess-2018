library(shiny)
library(datasets)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(plotrix)
#Wordcloud
library(NLP)
library(RColorBrewer)
library(tm)
library(dplyr)
library(wordcloud)
library(wordcloud2)
library(ggplot2)
library(syuzhet)
library(quanteda)
#Interface
library(DT)
library(shinyjs)
library(stringr)
library(googleVis)
library(scatterplot3d)

shinyUI(fluidPage(
  
  
  tags$img(src='nv.jpg',height = 150, width = 1200),
  
  #title of the chat analysis app
  titlePanel(title= h3(align="center",strong("NEW VISION CHAT ANALYSIS APPLICATION"))),
  
  # MAIN PAGE SETUP
  fluidRow(
    column(2,
           wellPanel(
             
             fileInput("file","UPLOAD FILE",
                       accept=c('text/csv', 'text/comma-separated-values,text/plain','word document')),
             tags$hr(),
             selectInput("plot", "DOWNLOAD GRAPHICS", 
                         choices = c("BarGraph","PieChart","WordCloud","sentimentAnalysis")),
             downloadButton('downloadPlot', 'Download'),
             tags$hr(),
             uiOutput("select"),
             br(),
             uiOutput("vx"),
             br(),
             uiOutput("vy"),
             br()
             #  uiOutput("vz")
             
           )),
    
    
    # Show a plot of the generated distribution
    column(10,
           wellPanel(
             selectInput('ds2', h5(strong("VISUALIZATION DASHBOARD:")),
                         c("Graphics"), "Graphics"),
             uiOutput("dynamic2")
             
             
           )
    )
  )))
