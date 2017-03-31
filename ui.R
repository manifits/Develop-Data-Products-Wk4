library(shiny)
library(plotly)

shinyUI(fluidPage(
  navbarPage("states.x77 Explorer",
             tabPanel("Main", sidebarPanel(
               checkboxGroupInput("regionID", label=h4("Select Region to Display"),
                                  c("Northeast"="Northeast",
                                    "South"="South",
                                    "North Central"="North Central",
                                    "West"="West"),
                                  selected=c("Northeast",
                                             "South",
                                             "North Central",
                                             "West"))),
               
               mainPanel(tabsetPanel(tabPanel('Plot',
                                              radioButtons("display", "Display by", 
                                                           c("Population"= "PopD",
                                                             "Income"="IncD",
                                                             "HS.Grad"="GradD"), 
                                                           selected="PopD",
                                                           inline=T),
                                              column(12,plotlyOutput("plot"))),

                                     tabPanel("Data",dataTableOutput(outputId="table"),
                                              downloadButton("downloadData","Download"))))),
             
             tabPanel("About",mainPanel(includeMarkdown("readme.Rmd"))))
))
