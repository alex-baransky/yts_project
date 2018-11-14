shinyServer(function(input, output) {
  
  # Reactive data that returns a dataframe filtered by user input, for heat map
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
  
  # Reactive data that returns a dataframe filtered by user input, for trend graphs
  trend_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(TopicDesc==input$trend_measure, LocationAbbr==input$trend_state))
               # mutate(hover=paste(LocationDesc, '<br>', "Sample Size", Sample_Size, "<br>",
               #                    "Low Confidence Limit", Low_Confidence_Limit, "<br>",
               #                    "High Confidence Limit", High_Confidence_Limit))
    }
    else {
      return(ms_data %>% 
               filter(TopicDesc==input$trend_measure, LocationAbbr==input$trend_state))
               # mutate(hover=paste(LocationDesc, '<br>', "Sample Size", Sample_Size, "<br>",
               #                    "Low Confidence Limit", Low_Confidence_Limit, "<br>",
               #                    "High Confidence Limit", High_Confidence_Limit)) 
    }
  })
  
  # Reactively create map title text
  map_title = reactive({
    paste(input$map_measure, 'of', ifelse(input$map_gender=='Overall', 'All', input$map_gender), input$hs_or_ms, 'Students in', input$map_year)
  })
  
  # Render heat map output
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
  
  # Render Overall state trend graph
  output$overall_trend = renderPlotly({
    ggplotly(ggplot(trend_data() %>% filter(Gender=='Overall'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response)))
  })
  
})
