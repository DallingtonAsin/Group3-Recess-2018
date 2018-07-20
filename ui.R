library(shinyjs)
library(shinydashboard)
shinyUI(fluidPage(
  # Add Javascript
  tags$head(
    tags$link(rel="stylesheet", type="text/css",href="css.css")
 
  ),
      
  
    dashboardPage(skin="green",
      
      dashboardHeader(title = tags$a(href='http://newvision.co.ug',
                                     tags$img(id="img",src='nv1.png'))),
      dashboardSidebar(
        tags$br(),
        tags$label("NEW VISION"),
        tags$br(),
        tags$label("UGANDA'S LEADING DAILY")
        
      ),
      dashboardBody(
        fluidRow(
        
        tags$h2("NEW VISION CHAT ANALYSIS APP"),
        
        uiOutput("app"))
        
        
      )
    )
    
    
  
  
))






