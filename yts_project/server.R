shinyServer(function(input, output) {
  
  # Reactive data that returns a dataframe filtered by user input, for heat map
  map_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(YEAR==input$map_year, TopicDesc==input$map_measure, Response==input$map_response) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit, '<br>', "Sample Size", Sample_Size)) %>%
               select(value=Data_Value, region=LocationAbbr, hover, Gender))
    }
    else {
      return(ms_data %>% 
               filter(YEAR==input$map_year, TopicDesc==input$map_measure, Response==input$map_response) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit, '<br>', "Sample Size", Sample_Size)) %>%
               select(value=Data_Value, region=LocationAbbr, hover, Gender))
    }
  })
  
  # Reactive data that returns a dataframe filtered by user input, for trend graphs
  trend_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(TopicDesc==input$trend_measure, LocationDesc==input$trend_state)) %>% 
               mutate(hover=paste(Data_Value, '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
    else {
      return(ms_data %>% 
               filter(TopicDesc==input$trend_measure, LocationDesc==input$trend_state)) %>% 
               mutate(hover=paste(Data_Value, '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
  })
  
  # Reactively create map title text
  map_title = reactive({
    paste(input$map_measure, 'of', input$hs_or_ms, 'Students in', input$map_year)
  })
  
  # Reactively create trend graph title text
  trend_title = reactive({
    paste(input$trend_measure, 'of', input$trend_state, input$hs_or_ms, 'Students Over Time')
  })
  
  output$trend_text = renderText({
    trend_title()
  })
  
  output$map_text = renderText({
    map_title()
  })
  
  # Render overall heat map output
  output$overall_map = renderPlotly({
    plot_geo(map_data() %>% filter(Gender=='Overall'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = max(map_data()$value)
      ) %>%
      colorbar(title = "Percent", ticksuffix = '%') %>%
      layout(
        title = 'Overall',
        geo = list(
          scope = 'usa',
          projection = list(type = 'albers usa'),
          showlakes = TRUE,
          lakecolor = toRGB('white')
        )
      )
  })
  
  # Render male heat map output
  output$male_map = renderPlotly({
    plot_geo(map_data() %>% filter(Gender=='Male'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = max(map_data()$value)
      ) %>%
      colorbar(title = "Percent", ticksuffix = '%') %>%
      layout(
        title = 'Male',
        geo = list(
          scope = 'usa',
          projection = list(type = 'albers usa'),
          showlakes = TRUE,
          lakecolor = toRGB('white')
        )
      )
  })
  
  # Render female heat map output
  output$female_map = renderPlotly({
    plot_geo(map_data() %>% filter(Gender=='Female'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = max(map_data()$value)
      ) %>%
      colorbar(title = "Percent", ticksuffix = '%') %>%
      layout(
        title = 'Female',
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
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Overall') +
               labs(col = 'Habit') + ylim(min(trend_data()$Data_Value), max(trend_data()$Data_Value)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render male state trend graph
  output$male_trend = renderPlotly({
    ggplotly(ggplot(trend_data() %>% filter(Gender=='Male'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Male') +
               labs(col = 'Habit') + ylim(min(trend_data()$Data_Value), max(trend_data()$Data_Value)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render female state trend graph
  output$female_trend = renderPlotly({
    ggplotly(ggplot(trend_data() %>% filter(Gender=='Female'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Female') +
               labs(col = 'Habit') + ylim(min(trend_data()$Data_Value), max(trend_data()$Data_Value)) +
               xlim(1999, 2017), tooltip='text')
  })
})