shinyServer(function(input, output) {
  
  # Reactive data that returns a dataframe filtered by user input, for usage heat map
  usage_map_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(YEAR==input$map_year, TopicDesc==input$map_topic, Response==input$map_response) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit, '<br>', "Sample Size", Sample_Size)) %>%
               select(value=Data_Value, region=LocationAbbr, hover, Gender))
    }
    else {
      return(ms_data %>% 
               filter(YEAR==input$map_year, TopicDesc==input$map_topic, Response==input$map_response) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit, '<br>', "Sample Size", Sample_Size)) %>%
               select(value=Data_Value, region=LocationAbbr, hover, Gender))
    }
  })
  
  # Reactive data that returns a dataframe filtered by user input, for usage trend graphs
  usage_trend_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(TopicDesc==input$trend_topic, LocationDesc==input$trend_state, !is.na(Data_Value))) %>% 
               mutate(hover=paste(paste0(Data_Value,'%'), '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
    else {
      return(ms_data %>% 
               filter(TopicDesc==input$trend_topic, LocationDesc==input$trend_state, !is.na(Data_Value))) %>% 
               mutate(hover=paste(paste0(Data_Value,'%'), '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
  })
  
  # Reactive data that returns a dataframe filtered by user input, for cessation heat map
  cessation_map_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(YEAR==input$cessation_map_year, MeasureDesc==input$cessation_map_measure) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit, '<br>', "Sample Size", Sample_Size)) %>%
               select(value=Data_Value, region=LocationAbbr, hover, Gender))
    }
    else {
      return(ms_data %>% 
               filter(YEAR==input$cessation_map_year, MeasureDesc==input$cessation_map_measure) %>%
               mutate(hover=paste(LocationDesc, '<br>', "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                                  "High Confidence Limit", High_Confidence_Limit, '<br>', "Sample Size", Sample_Size)) %>%
               select(value=Data_Value, region=LocationAbbr, hover, Gender))
    }
  })
  
  # Reactive data that returns a dataframe filtered by user input, for cessation trend graphs
  cessation_trend_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_data %>% 
               filter(TopicDesc=='Cessation', LocationDesc==input$cessation_state, !is.na(Data_Value))) %>% 
               mutate(hover=paste(paste0(Data_Value,'%'), '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
    else {
      return(ms_data %>% 
               filter(TopicDesc=='Cessation', LocationDesc==input$cessation_state, !is.na(Data_Value))) %>% 
               mutate(hover=paste(paste0(Data_Value,'%'), '<br>', "Year", YEAR, '<br>',
                           "Standard Error", Data_Value_Std_Err, "<br>",
                           "Low Confidence Limit", Low_Confidence_Limit, "<br>",
                           "High Confidence Limit", High_Confidence_Limit, '<br>',
                           "Sample Size", Sample_Size))
    }
  })
  
  # Reactive data that returns a dataframe filtered by user input, for usage diff heat map
  usage_diff_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_diff %>% 
               filter(MeasureDesc==input$usage_diff_measure, Response==input$usage_diff_response) %>%
               select(value=diff, region=LocationAbbr, hover, Gender))
    }
    else {
      return(ms_diff %>% 
               filter(MeasureDesc==input$usage_diff_measure, Response==input$usage_diff_response) %>%
               select(value=diff, region=LocationAbbr, hover, Gender))
    }
  })
  
  # Reactive data that returns a dataframe filtered by user input, for cessation diff heat map
  cessation_diff_data = reactive({
    if (input$hs_or_ms == 'High School'){
      return(hs_diff %>% 
               filter(MeasureDesc==input$cessation_diff_measure) %>%
               select(value=diff, region=LocationAbbr, hover, Gender))
    }
    else {
      return(ms_diff %>% 
               filter(MeasureDesc==input$cessation_diff_measure) %>%
               select(value=diff, region=LocationAbbr, hover, Gender))
    }
  })
  
  # Reactive that returns max value for legend scale in usage heat map based on current filtered data
  usage_max_zlim = reactive({
    if (input$hs_or_ms == 'High School'){
      return(max(hs_data %>% 
                   filter(Response==input$map_response, TopicDesc==input$map_topic) %>%
                   select(Data_Value),
                 na.rm = TRUE))
    }
    
    else {
      return(max(ms_data %>% 
                   filter(Response==input$map_response, TopicDesc==input$map_topic) %>% 
                   select(Data_Value),
                 na.rm = TRUE))
    }
  })
  
  # Returns max value for legend scale in cessation heat map based on current filtered data
  cessation_max_zlim = reactive({
    if (input$hs_or_ms == 'High School'){
      return(max(hs_data %>% 
                   filter(MeasureDesc==input$cessation_map_measure) %>%
                   select(Data_Value),
                 na.rm = TRUE))
    }
    
    else {
      return(max(ms_data %>% 
                   filter(MeasureDesc==input$cessation_map_measure) %>%
                   select(Data_Value),
                 na.rm = TRUE))
    }
  })
  
  # Reactive that returns max value for usage trend graph y axis limit (autoscale)
  usage_max_ylim = reactive({
    if (input$hs_or_ms == 'High School') {
      return(max(with(hs_data %>% filter(TopicDesc==input$trend_topic, LocationDesc==input$trend_state, !is.na(Data_Value)),
                  # This long nested ifelse checks the maximum value of the High_Confidence_Limit and sets the y axis upper bound to
                  # just above that value.
                  ifelse(High_Confidence_Limit > 75, 100, 
                         ifelse(High_Confidence_Limit > 60, 75,
                                ifelse(High_Confidence_Limit > 50, 60,
                                       ifelse(High_Confidence_Limit > 40, 50,
                                              ifelse(High_Confidence_Limit > 30, 40,
                                                     ifelse(High_Confidence_Limit > 20, 30, 20)))))))))
    }
    
    else {
      return(max(with(ms_data %>% filter(TopicDesc==input$trend_topic, LocationDesc==input$trend_state, !is.na(Data_Value)),
                      ifelse(High_Confidence_Limit > 75, 100, 
                             ifelse(High_Confidence_Limit > 60, 75,
                                    ifelse(High_Confidence_Limit > 50, 60,
                                           ifelse(High_Confidence_Limit > 40, 50,
                                                  ifelse(High_Confidence_Limit > 30, 40,
                                                         ifelse(High_Confidence_Limit > 20, 30, 20)))))))))
    }
  })
  
  # Reactive that returns max value for cessation trend graph y axis limit (autoscale)
  cessation_max_ylim = reactive({
    if (input$hs_or_ms == 'High School') {
      return(max(with(hs_data %>% filter(TopicDesc=='Cessation', LocationDesc==input$cessation_state, !is.na(Data_Value)),
                      ifelse(High_Confidence_Limit > 75, 100, 
                             ifelse(High_Confidence_Limit > 60, 75,
                                    ifelse(High_Confidence_Limit > 50, 60,
                                           ifelse(High_Confidence_Limit > 40, 50,
                                                  ifelse(High_Confidence_Limit > 30, 40,
                                                         ifelse(High_Confidence_Limit > 20, 30, 20)))))))))
    }
    
    else {
      return(max(with(ms_data %>% filter(TopicDesc=='Cessation', LocationDesc==input$cessation_state, !is.na(Data_Value)),
                      ifelse(High_Confidence_Limit > 75, 100, 
                             ifelse(High_Confidence_Limit > 60, 75,
                                    ifelse(High_Confidence_Limit > 50, 60,
                                           ifelse(High_Confidence_Limit > 40, 50,
                                                  ifelse(High_Confidence_Limit > 30, 40,
                                                         ifelse(High_Confidence_Limit > 20, 30, 20)))))))))
    }
  })
  
  # Usage map title text
  output$usage_map_text = renderText({
    paste(input$map_response, input$map_topic, 'of', input$hs_or_ms, 'Students in', input$map_year)
  })
  
  # Usage trend title text
  output$usage_trend_text = renderText({
    paste(input$map_response, input$trend_topic, 'of', input$trend_state, input$hs_or_ms, 'Students Over Time')
  })
  
  # Cessation map title text
  output$cessation_map_text = renderText({
    paste(input$cessation_map_topic, 'of', input$hs_or_ms, 'Students in', input$cessation_map_year)
  })
  
  # Cessation trend title text
  output$cessation_trend_text = renderText({
    paste(input$cessation_state, input$hs_or_ms, 'Student Tobacco Cessation Over Time')
  })
  
  # Usage diff map title text
  output$usage_diff_text = renderText({
    paste('Overall Change of', input$usage_diff_response, input$usage_diff_measure, input$hs_or_ms, 'Students')
  })
  
  # Cessation diff map title text
  output$cessation_diff_text = renderText({
    paste('Overall Change of', input$cessation_diff_measure, input$hs_or_ms, 'Students')
  })
  
  ########################################
  #### START OF USAGE HEAT MAP OUTPUT ####
  ########################################
  
  # Render overall usage heat map output
  output$usage_map_overall = renderPlotly({
    plot_geo(usage_map_data() %>% filter(Gender=='Overall'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = usage_max_zlim()
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
  
  # Render male usage heat map output
  output$usage_map_male = renderPlotly({
    plot_geo(usage_map_data() %>% filter(Gender=='Male'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = usage_max_zlim()
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
  
  # Render female usage heat map output
  output$usage_map_female = renderPlotly({
    plot_geo(usage_map_data() %>% filter(Gender=='Female'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = usage_max_zlim()
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
  
  ###########################################
  #### START OF USAGE TREND GRAPH OUTPUT ####
  ###########################################
  
  # Render Overall state usage trend graph
  output$usage_trend_overall = renderPlotly({
    ggplotly(ggplot(usage_trend_data() %>% filter(Gender=='Overall'), aes(x=YEAR)) +
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
               labs(col = 'Habit') + ylim(0, ifelse(input$usage_trend_autofit, usage_max_ylim(), 100)) +
               # Stnadardize the x axis scale
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render male state usage trend graph
  output$usage_trend_male = renderPlotly({
    ggplotly(ggplot(usage_trend_data() %>% filter(Gender=='Male'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=Response), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Male') +
               labs(col = 'Habit') + ylim(0, ifelse(input$usage_trend_autofit, usage_max_ylim(), 100)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render female state usage trend graph
  output$usage_trend_female = renderPlotly({
    ggplotly(ggplot(usage_trend_data() %>% filter(Gender=='Female'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=Response)) +
               geom_point(aes(y=Data_Value, col=Response, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=Response), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Female') +
               labs(col = 'Habit') + ylim(0, ifelse(input$usage_trend_autofit, usage_max_ylim(), 100)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  ############################################
  #### START OF CESSATION HEAT MAP OUTPUT ####
  ############################################
  
  # Render overall cessation heat map output
  output$cessation_map_overall = renderPlotly({
    plot_geo(cessation_map_data() %>% filter(Gender=='Overall'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = cessation_max_zlim()
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
  
  # Render male cessation heat map output
  output$cessation_map_male = renderPlotly({
    plot_geo(cessation_map_data() %>% filter(Gender=='Male'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = cessation_max_zlim()
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
  
  # Render female cessation heat map output
  output$cessation_map_female = renderPlotly({
    plot_geo(cessation_map_data() %>% filter(Gender=='Female'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'Blues', zmin = 0, zmax = cessation_max_zlim()
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
  
  ###############################################
  #### START OF CESSATION TREND GRAPH OUTPUT ####
  ###############################################
  
  # Render overall state cessation trend graph
  output$cessation_trend_overall = renderPlotly({
    ggplotly(ggplot(cessation_trend_data() %>% filter(Gender=='Overall'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=MeasureDesc)) +
               geom_point(aes(y=Data_Value, col=MeasureDesc, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=MeasureDesc), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Overall') +
               labs(col = 'Type') + ylim(0, ifelse(input$cessation_trend_autofit, cessation_max_ylim(), 100)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render male state cessation trend graph
  output$cessation_trend_male = renderPlotly({
    ggplotly(ggplot(cessation_trend_data() %>% filter(Gender=='Male'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=MeasureDesc)) +
               geom_point(aes(y=Data_Value, col=MeasureDesc, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=MeasureDesc), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Male') +
               labs(col = 'Type') + ylim(0, ifelse(input$cessation_trend_autofit, cessation_max_ylim(), 100)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  # Render female state cessation trend graph
  output$cessation_trend_female = renderPlotly({
    ggplotly(ggplot(cessation_trend_data() %>% filter(Gender=='Female'), aes(x=YEAR)) +
               geom_line(aes(y=Data_Value, col=MeasureDesc)) +
               geom_point(aes(y=Data_Value, col=MeasureDesc, text=hover)) +
               geom_ribbon(aes(ymin=Low_Confidence_Limit, ymax=High_Confidence_Limit, col=MeasureDesc), alpha=0.2) +
               xlab('Year') + ylab('Percent') +
               ggtitle('Female') +
               labs(col = 'Type') + ylim(0, ifelse(input$cessation_trend_autofit, cessation_max_ylim(), 100)) +
               xlim(1999, 2017), tooltip='text')
  })
  
  #######################################################
  #### START OF USAGE/CESSATION DIFF HEAT MAP OUTPUT ####
  #######################################################
  
  # Render Overall usage diff heat map
  output$usage_diff_overall = renderPlotly({
    plot_geo(usage_diff_data() %>% filter(Gender=='Overall'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'RdBu', zmin = -100, zmax = 100
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
  
  # Render male usage diff heat map
  output$usage_diff_male = renderPlotly({
    plot_geo(usage_diff_data() %>% filter(Gender=='Male'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'RdBu', zmin = -100, zmax = 100
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
  
  # Render female usage diff heat map
  output$usage_diff_female = renderPlotly({
    plot_geo(usage_diff_data() %>% filter(Gender=='Female'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'RdBu', zmin = -100, zmax = 100
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
  
  # Render overall cessation diff heat map
  output$cessation_diff_overall = renderPlotly({
    plot_geo(cessation_diff_data() %>% filter(Gender=='Overall'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'RdBu', zmin = -100, zmax = 100
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
  
  # Render male cessation diff heat map
  output$cessation_diff_male = renderPlotly({
    plot_geo(cessation_diff_data() %>% filter(Gender=='Male'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'RdBu', zmin = -100, zmax = 100
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
  
  # Render female cessation diff heat map
  output$cessation_diff_female = renderPlotly({
    plot_geo(cessation_diff_data() %>% filter(Gender=='Female'), locationmode = 'USA-states') %>%
      add_trace(
        z = ~value, text = ~hover, locations = ~region,
        color = ~value, colors = 'RdBu', zmin = -100, zmax = 100
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
  
})