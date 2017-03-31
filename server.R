library(shiny)
library(plotly)

shinyServer(function(input, output){
  map_options <- list(scope='usa',
                        projection=list(type='albers usa'),
                        showlakes = TRUE,
                        lakecolor = toRGB('white'))  
    
  statedata <- data.frame(state.region, state.abb, state.name,
                          Pop = as.vector(state.x77[,1]),
                          Income=as.vector(state.x77[,2]),
                          Grad=as.vector(state.x77[,6]),
                          Illiteracy=as.vector(state.x77[,2]))
  statedata$hover1 <- with(statedata, paste(state.name))
  statedata$hover2 <- with(statedata, paste(state.name,
                                            '<br>', "HS Grad:", Grad,
                                            '<br>', "Illiteracy:", Illiteracy))
  
  
  data1 <- reactive({
   subset(statedata, state.region %in% input$regionID)
  })
  
  display1 <- reactive({
    tmp1 <- input$display
  })
  
  output$plot <- renderPlotly({
    data2 <- data1()
    display2 <- display1()
    
    if(display2=="PopD") {
      plot_ly(data2, z=~Pop, text=~hover1, locations=~state.abb,
              type = 'choropleth', locationmode = 'USA-states',
              color = data2$Pop, colors = 'Blues',
              marker = list(line=borders)) %>%
      layout(title = 'US Population in 1975', geo=map_options)
    
    } else if(display2=="IncD") {
    
      plot_ly(data2, z=~Income, text=~hover1, locations=~state.abb,
              type = 'choropleth', locationmode = 'USA-states',
              color = data2$Income, colors = 'Greens',
              marker = list(line=borders)) %>%
      layout(title = 'US Per Capita Income in 1974', geo=map_options)
      
    } else
      
      plot_ly(data2, z=~Grad, text=~hover2, locations=~state.abb,
              type = 'choropleth', locationmode = 'USA-states',
              color = data2$Grad, colors = 'Oranges',
              marker = list(line=borders)) %>%
      layout(title = '% US HS-Grads and Illiteracy Per Population in 1970', geo=map_options)

  })
  
  dataTable <- reactive({
    tmp2 <- data1()
    tmp2 <- tmp2[-c(8,9)]
  })
  

  output$table <- renderDataTable({
    dataTable()}, options = list(filter="top", pageLength=50))
  
  output$downloadData <- downloadHandler(filename = 'data.csv',
                                         content = function(file)
                                         {
                                           write.csv(dataTable(), file, row.names=FALSE)
                                         })
})