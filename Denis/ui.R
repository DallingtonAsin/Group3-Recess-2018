library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Moscow we go"),
  
  sidebarLayout(position="right",
    sidebarPanel(h3("this is side bar panel"),h4("widget4"),h5("widget5")),
    mainPanel(h4("this is manin panel text , output is displayed here"),
              h5("this ios the output5")
  )
)
  
)
)