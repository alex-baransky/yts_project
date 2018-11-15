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
               filter(TopicDesc==input$trend_measure, LocationDesc==input$trend_state, !is.na(Data_Value))) %>% 
               mutate(hover=paste(Data_Value, '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
    else {
      return(ms_data %>% 
               filter(TopicDesc==input$trend_measure, LocationDesc==input$trend_state, !is.na(Data_Value))) %>% 
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
  
  # Trend title text
  output$trend_text = renderText({
    trend_title()
  })
  
  # Map title text
  output$map_text = renderText({
    map_title()
  })
  
  # Render overall heat map output
  output$overall_map = renderPlotly({
    plot_geo(map_data() %>% filter(Gender=='Overall'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = max(map_data()$value, na.rm = TRUE)
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
        color = ~value, colors = 'Blues', zmin = 0, zmax = max(map_data()$value, na.rm = TRUE)
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
        color = ~value, colors = 'Blues', zmin = 0, zmax = max(map_data()$value, na.rm = TRUE)
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
               # Plots the line
               geom_line(aes(y=Data_Value, col=Response)) +
               # Plots the points
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               # Plots confidence intervals
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=Response), alpha=0.2) +
               # Change x/y labels
               xlab('Year') + ylab('Percent') +
               # Add plot title
               ggtitle('Overall') +
               # Add legend title and standardize the y axis scale
               labs(col = 'Habit') + ylim(min(trend_data()$Low_Confidence_Limit, na.rm = TRUE), max(trend_data()$High_Confidence_Limit, na.rm = TRUE)) +
               # Stnadardize the x axis scale
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render male state trend graph
  output$male_trend = renderPlotly({
    ggplotly(ggplot(trend_data() %>% filter(Gender=='Male'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=Response), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Male') +
               labs(col = 'Habit') + ylim(min(trend_data()$Low_Confidence_Limit, na.rm = TRUE), max(trend_data()$High_Confidence_Limit, na.rm = TRUE)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render female state trend graph
  output$female_trend = renderPlotly({
    ggplotly(ggplot(trend_data() %>% filter(Gender=='Female'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=Response), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Female') +
               labs(col = 'Habit') + ylim(min(trend_data()$Low_Confidence_Limit, na.rm = TRUE), max(trend_data()$High_Confidence_Limit, na.rm = TRUE)) +
               xlim(1999, 2017), tooltip='text')
  })
  
})