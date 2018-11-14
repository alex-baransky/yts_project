shinyServer(function(input, output) {
  
  # Reactive data that returns a data set filtered by user input
  map_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(YEAR==input$map_year, TopicDesc==input$map_measure, Response==input$map_response, Gender==input$map_gender) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Sample Size", Sample_Size, "<br>",
                                  "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit)) %>%
               select(value=Data_Value, region=LocationAbbr, hover))
    }
    else {
      return(ms_data %>% 
               filter(YEAR==input$map_year, TopicDesc==input$map_measure, Response==input$map_response, Gender==input$map_gender) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Sample Size", Sample_Size, "<br>",
                                  "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit)) %>%
               select(value=Data_Value, region=LocationAbbr, hover))
    }
  })
  
  # Reactively create map title text
  map_title = reactive({
    paste(input$map_measure, 'of', ifelse(input$map_gender=='Overall', 'All', input$map_gender), input$hs_or_ms, 'Students in', input$map_year)
  })
  
  # Render map output
  output$map = renderPlotly({
    plot_geo(map_data(), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues'
      ) %>%
      colorbar(title = "Percent of Students") %>%
      layout(
        title = map_title(),
        geo = list(
          scope = 'usa',
          projection = list(type = 'albers usa'),
          showlakes = TRUE,
          lakecolor = toRGB('white')
        )
      )
  })
  
})
