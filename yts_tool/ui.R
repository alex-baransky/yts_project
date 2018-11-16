shinyUI(dashboardPage(
  # Set the theme color to blue
  skin = 'blue',
  # Give a title
  dashboardHeader(title = "YTS DataVis Tool"),
  dashboardSidebar(
    sidebarMenu(
      # Create different tabs
      menuItem("Introduction", tabName = "intro", icon = icon("info-circle")),
      menuItem("How to Use", tabName = 'how_to_use', icon = icon("question-circle")),
      menuItem("Usage Map", tabName = "usage_map", icon = icon("globe")),
      menuItem("Usage Trends", tabName = 'usage_trends', icon = icon("chart-line")),
      menuItem("Cessation Map", tabName = "cessation_map", icon = icon("globe")),
      menuItem("Cessation Trends", tabName = "cessation_trends", icon = icon("chart-line")),
      menuItem('Overall Usage Change', tabName = 'usage_diff', icon = icon("map")),
      menuItem('Overall Cessation Change', tabName = 'cessation_diff', icon = icon("map")),
      menuItem('Conclusion', tabName = 'conclusion', icon = icon('lightbulb-o'))
    ),
    
    # Create radio button to choose high school or middle school data set
    radioButtons('hs_or_ms', 'Choose which data to inspect:', choices = c('Middle School', 'High School'), selected = 'Middle School')
  ),
  dashboardBody(
    tabItems(
      # Intro tab
      tabItem(tabName = "intro",
              # Title text
              fluidRow(column(width = 8,
                              align="center",
                              offset = 2,
                              box(
                                width = 20, 
                                background = 'light-blue',
                                h1('Youth Tobacco Survey Data Visualization Tool'),
                                h3('Alex Baransky')
                                ))),
              # Title picture
              fluidRow(column(
                width = 8,
                align = 'center',
                offset = 2,
                div(img(src="cigarettes.jpg", height='65%', width='65%')),
                br()
              )),
              # Title body
              fluidRow(column(width = 10,
                              align="justified",
                              offset = 1,
                              box(
                                width = 20,
                                background = 'light-blue',
                                p('The Youth Tobacco Survey (YTS) data set contains information collected by
                                   the Centers for Disease Control and Prevention on smoking and cessation (quitting) habits of 
                                   students in grades 6 through 12 (Middle School and High School). The version of the survey used for this
                                   application includes observations from 1999 to 2017. Each observation is a state summary of the perctenage 
                                   of students who reported to use tobacco or have a desire to quit. This is further broken down by gender, 
                                   tobacco use frequency, and desire or attempt to quit. In addition
                                   to using percentages, the dataset also contains sample size, standard error and confidence intervals.',
                                   style="font-size:115%;"),
                                hr(),
                                p('The purpose of this application is to visualize country- and state-level trends
                                  in the reported percentages of tobacco-using students. The visualizations should aid in
                                  finding problem states where cigarette or smokeless tobacco use has resisted decline, or even increased,
                                  in the past 18 years. This tool can also help detect areas of the country where tobacco use has substantially
                                  declined, shining a light on potentially effective education or anti-tobacco programs. The visualizations
                                  can also help detect possible deviations between male and female trends. The goal is to extract insights from 
                                  the data that can aid anti-tobacco media campaigns and tobacco education/cessation programs in targeting high risk states.
                                  The programs can be further tagreted towards male or female audiences if there is a deviation in trend for specific states.',
                                  style="font-size:115%;")
                              ))
              )),
      # How to use tab
      tabItem(tabName = "how_to_use",
              # Title text
              fluidRow(column(width = 8,
                              align="center",
                              offset = 2,
                              box(
                                width = 20, 
                                background = 'light-blue',
                                h1('How to Use This Tool')
                              ))),
              # Title body
              fluidRow(column(width = 10,
                              align="justified",
                              offset = 1,
                              box(
                                width = 20,
                                background = 'light-blue',
                                h3('Overview', align='center'),
                                p('This tool has been made in a way to tell a story about tobacco use trends in the data if you follow the order of
                                  the tabs in the left panel. There will be suggestions of areas to inspect on each page, however feel free to explore
                                  if you want to inspect the data more closely.',
                                  style="font-size:115%;"),
                                hr(),
                                h3('Data Selection', align='center'),
                                p('The data is split into two portions: Middle School and High School. The radio buttons in the left panel allow you
                                  to choose which data set to inspect Choosing one of the two will update the plots in the application.',
                                  style="font-size:115%;"),
                                hr(),
                                h3('Category Selection', align='center'),
                                p('There will be input widgets at the top of each page. Select the desired combination of inputs to inspect that subset
                                  of the data.',
                                  style="font-size:115%;"),
                                hr(),
                                h3('Plot Layout', align='center'),
                                p('Each page will have three versions of the same type of plot: Overall, Male, and Female. These plots are associated
                                  with the different gender groups, and allow the user to see differences in data between gender.',
                                  style="font-size:115%;"),
                                hr(),
                                h3('Using the Plots', align='center'),
                                p('The plots are rendered using the Plotly package. You can hover over data points to see a popup with more information
                                  about that particular point. For line plots, you can click and drag on the plot to zoom in on an interesting area. Double
                                  click on the plot to reset the zoom to default.',
                                  style="font-size:115%;")
                                ))
                              )),
      # Usage heat map tab
      tabItem(tabName = "usage_map",
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'justified',
                # Text description
                h1('United States Youth Tobacco Usage Heat Map', align='center'),
                p('Use this heat map to visualize country-level trends of youth tobacco use. Choose a category and observe the change in 
                  percentage in different states over time. A white state indicates that no data is available for that year and category
                  combination. You can click the "Play" button to the bottom right of the year slider widget to see an animation of the state percentage
                  changes over time.',
                  style="font-size:115%;"),
                p('NOTE: The legend scale is not necessarily constant for different catgeory combinations.',
                  style="font-size:115%;"),
                hr(),
                p('Suggestion: Select "Cigarette Use" and any habit type and click the "Play" button. Note how the percentage
                  decreases overall as the year increases, indicating a descreasing trend in youth cigarette use in the US.',
                  style="font-size:115%;"),
                p('Suggestion: Select "Smokeless Tobacco Use" and inspect the difference between Male and Female heat maps. The map 
                  shows that men generally report a higher usage percentage of smokeless tobacco use than women.',
                  style="font-size:115%;")
              )),
              fluidRow(box(
                # Widgets
                column(
                  sliderInput('map_year', 'Choose a year:',
                              min = 1999,
                              max = 2017,
                              value = 1999,
                              round = TRUE,
                              sep = '',
                              animate = animationOptions(interval = 700,
                                                         playButton = HTML("<h4>Play</h4>"))),
                  width = 6
                ),
                column(
                  radioButtons('map_topic', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
                  radioButtons('map_response', 'Choose a habit:', choices=c('Ever', 'Current', 'Frequent'), selected = 'Ever'),
                  width = 6
                ),
                width = 12
              )),
              # Map title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('usage_map_text'))
              )),
              # Plotly overall map output
              fluidRow(box(plotlyOutput("usage_map_overall"), width = 12)),
              fluidRow(
                # Male map
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('usage_map_male')
                ), width = 6),
                # Female map
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('usage_map_female')
                ), width = 6))
              ),
      # Usage trend tab
      tabItem(tabName = 'usage_trends',
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'justified',
                # Text description
                h1('State-Level Youth Tobacco Usage Trends', align='center'),
                p('Use this graph to visualize state-level youth tobacco usage trends. Choose a state and a category to view the change
                  in reported percentage over time for that state. The gray surrounding the lines indicate the confidence interval for each point.
                  If data is not shown for certain years, that means the data is not available for that year in that state.',
                  style="font-size:115%;"),
                p('NOTE: You can check the "Auto-scale y-axis" box to automatically adjust the y-axis scope. If this is checked, the y-axis will
                  not necessarily be constant for different catgeories and states.',
                  style="font-size:115%;"),
                hr(),
                p('Suggestion: Choose the High School data and select Alabama smokeless tobacco use. Note the spike in ever use in 2012. Spikes like
                  this one may warrant closer investigation to detect predictors for change in smokeless tobacco use.',
                  style="font-size:115%;"),
                p('Suggestion: Choose the High School data and select Missouri smokeless tobacco use. Note the large difference between male and 
                  female percentages. This might indicate that anti-smokeless tobacco campaigns should be more heavily targeted towards men in
                  Missouri.',
                  style="font-size:115%;")
              )),
              # Widgets
              fluidRow(box(
                selectInput('trend_state', 'Choose a state:', choices=unique(ms_data$LocationDesc)[order(unique(ms_data$LocationDesc))]),
                radioButtons('trend_topic', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
                checkboxInput('usage_trend_autofit', 'Auto-scale y-axis', value=FALSE),
                width = 12
              )),
              # Graph title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('usage_trend_text'))
              )),
              # Overall graph
              fluidRow(box(plotlyOutput('usage_trend_overall'), width = 12)),
              fluidRow(
                # Male graph
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('usage_trend_male')
                ), width = 6),
                # Female graph
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('usage_trend_female')
                ), width = 6))
              ),
      # Cessation map tab
      tabItem(tabName = 'cessation_map',
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'justified',
                # Text description
                h1('United States Youth Tobacco Cessation Heat Map', align='center'),
                p('Use this heat map to visualize country-level trends of youth tobacco cessation. Choose a category and observe the change in 
                  percentage in different states over time. A white state indicates that no data is available for that year and category
                  combination. You can click the "Play" button to the bottom right of the year slider widget to see an animation of the state percentage
                  changes over time.',
                  style="font-size:115%;"),
                p('NOTE: The legend scale is not constant between the two catgeories.',
                  style="font-size:115%;"),
                hr(),
                p('Suggestion: Choose the Middle School data, select "Quit Attempt," and click the "Play" button. Note how the percentage increases in more
                  resent years. Choose the High School data set and click the "Play" button again. The percentage appears to stay relatively constant over time.
                  This may suggest that Middle School students have a greater desire to quit now than they did 10 years ago, and that tobacco cessation programs
                  may have more success in helping students quit.',
                  style="font-size:115%;")
              )),
              fluidRow(box(
                # Widgets
                column(
                  sliderInput('cessation_map_year', 'Choose a year:',
                              min = 1999,
                              max = 2017,
                              value = 1999,
                              round = TRUE,
                              sep = '',
                              animate = animationOptions(interval = 700,
                                                         playButton = HTML("<h4>Play</h4>"))),
                  width = 6
                ),
                column(
                  radioButtons('cessation_map_measure', 'Choose a category:', choices=c('Quit Attempt', 'Want to Quit')),
                  width = 6
                ),
                width = 12
              )),
              # Map title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('cessation_map_text'))
              )),
              # Plotly overall map output
              fluidRow(box(plotlyOutput("cessation_map_overall"), width = 12)),
              fluidRow(
                # Male map
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('cessation_map_male')
                ), width = 6),
                # Female map
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('cessation_map_female')
                ), width = 6))
      ),
      # Cessation trend tab
      tabItem(tabName = 'cessation_trends',
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'justified',
                # Text description
                h1('State-Level Youth Tobacco Cessation Trends', align='center'),
                p('Use this graph to visualize state-level youth tobacco cessation trends. Choose a state to view the change
                  in reported percentage over time for that state. The gray surrounding the lines indicate the confidence interval for each point.
                  If data is not shown for certain years, that means the data is not available for that year in that state.',
                  style="font-size:115%;"),
                p('NOTE: You can check the "Auto-scale y-axis" box to automatically adjust the y-axis scope. If this is checked, the y-axis will
                  not necessarily be constant for different states.',
                  style="font-size:115%;"),
                hr(),
                p('Suggestion: Explore some different states. Note that the gap between "Quit Attempt" and "Want to Quit" seems to be widening, with
                  "Quit Attempt" overtaking "Want to Quit." This is an interesting trend as one would expect that students who want to quit would be
                  more prevelant than students attempting to quit. This may indicate that while tobacco cessation programs are available, there are not
                  enough resources being dedicated to tobacco education programs.',
                  style="font-size:115%;"),
                p('Suggestion: Choose the High School data and select North Dakota. In the past few years, it appears that the male trend has flattened out
                  while the female trend is starting to show a negative slope. This could indicate that more resources should be allocated for tobacco education 
                  and cessation programs that target women.',
                  style="font-size:115%;")
              )),
              # Widgets
              fluidRow(box(
                selectInput('cessation_state', 'Choose a state:', choices=unique(ms_data$LocationDesc)[order(unique(ms_data$LocationDesc))]),
                checkboxInput('cessation_trend_autofit', 'Auto-scale y-axis', value=FALSE),
                width = 12
              )),
              # Graph title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('cessation_trend_text'))
              )),
              # Overall graph
              fluidRow(box(plotlyOutput('cessation_trend_overall'), width = 12)),
              fluidRow(
                # Male graph
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('cessation_trend_male')
                ), width = 6),
                # Female graph
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('cessation_trend_female')
                ), width = 6))
      ),
      # Usage diff heat map tab
      tabItem(tabName = 'usage_diff',
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'justified',
                # Text description
                h1('United States Youth Tobacco Usage Overall Change', align='center'),
                p('Use this heat map to visualize country-level overall change of youth tobacco usage. Choose a category and observe the change in 
                  percentage between the earliest and most recent year data available in different states. Darker blue indicates a more positive 
                  increase and darker red indicates a more negative decrease. A white state indicates that no data is available for that category.',
                  style="font-size:115%;"),
                hr(),
                p('Suggestion: Note the overwhelmingly negative change in "Cigarette Use" for both Middle School and High School students. The change
                  is least dramatic for ever users and most dramatic for frequent user. This is a good sign that youth cigarette use has declined over
                  the past 18 years.',
                  style="font-size:115%;"),
                p('Suggestion: Note the much more equally distributed change in "Smokeless Tobacco Use" for High School students. The most dramatic changes
                  occur in the frequent use category. Also of note is the very one-sided (heavily postive or heavily negative) change in female Middle
                  School students use of smokeless tobacco. This could indicate that smokeless tobacco is becoming more popular among women and could
                  support more female-targeted smokeless tobacco education programs.',
                  style="font-size:115%;")
              )),
              fluidRow(box(
                # Widgets
                column(
                  radioButtons('usage_diff_measure', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
                  width = 6
                ),
                column(
                  radioButtons('usage_diff_response', 'Choose a habit:', choices=c('Ever', 'Current', 'Frequent'), selected = 'Ever'),
                  width = 6
                ),
                width = 12
              )),
              # Map title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('usage_diff_text'))
              )),
              # Plotly overall map output
              fluidRow(box(plotlyOutput("usage_diff_overall"), width = 12)),
              fluidRow(
                # Male map
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('usage_diff_male')
                ), width = 6),
                # Female map
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('usage_diff_female')
                ), width = 6))
      ),
      # Cessation map tab
      tabItem(tabName = 'cessation_diff',
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'justified',
                # Text description
                h1('United States Youth Tobacco Cessation Overall Change', align='center'),
                p('Use this heat map to visualize country-level overall change of youth tobacco cessation. Choose a category and observe the change in 
                  percentage between the earliest and most recent year data available in different states. Darker blue indicates a more positive 
                  increase and darker red indicates a more negative decrease. A white state indicates that no data is available for that category.',
                  style="font-size:115%;"),
                hr(),
                p('Suggestion: Note the general overall increase in "Quit Attempt" and overall general decrease in "Want to Quit" for both High School
                  and Middle School students. As mentioned earlier, this could indicate that tobacco cessation programs are plentiful and that tobacco eduction
                  programs are sparse. Therefore, students with the desire to quit on their own have the ability to do so, but students without the quitting
                  mindset do not have the resources available to them to change their mind. Also noteworthy is the difference in change in different states for
                  male and female High School students who have attempted to quit, particularly in the North and South East. This could support more specific
                  gender-targeted tobacco cessation programs in different states.',
                  style="font-size:115%;")
              )),
              fluidRow(box(
                # Widgets
                column(
                  radioButtons('cessation_diff_measure', 'Choose a category:', choices=c('Quit Attempt', 'Want to Quit')),
                  width = 6
                ),
                width = 12
              )),
              # Map title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('cessation_diff_text'))
              )),
              # Plotly overall map output
              fluidRow(box(plotlyOutput("cessation_diff_overall"), width = 12)),
              fluidRow(
                # Male map
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('cessation_diff_male')
                ), width = 6),
                # Female map
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('cessation_diff_female')
                ), width = 6))
      ),
      # Conclusion tab
      tabItem(tabName = "conclusion",
              # Title text
              fluidRow(column(width = 8,
                              align="center",
                              offset = 2,
                              box(
                                width = 20, 
                                background = 'light-blue',
                                h1('Conclusion')
                              ))),
              # Title body
              fluidRow(column(width = 10,
                              align="justified",
                              offset = 1,
                              box(
                                width = 20,
                                background = 'light-blue',
                                p('I feel the most important part of data science is getting the data to a form where it is usable; someone
                                  once described this to me as "activating the data." I set out to find varying trends in this data set between different
                                  genders, education level, and tobacco usage, and the result was a comprehensive visualization tool that will allow
                                  even a non-data scientist to identify areas of interest. Identifying these areas of interest allows organizations to
                                  wisely invest time and money into further investigation of potential topics that will produce results. Through the use of this
                                  tool, I have demonstrated the power of visualization and how it can be used to direct business decisions.',
                                  style="font-size:115%;"),
                                p('In terms of the YTS dataset specifically, I identified many areas of interest. I think the most dramatic discovery was the
                                  heavy increase of smokeless tobacco use in the past couple of years. This contrasts with the almost universal decrease in cigarette use.
                                  It is possible that smokeless tobacco has been slightly overlooked in youth tobacco education programs and my findings show that it is
                                  definitely an important topic and demands the necessary resources to prevent youth from picking up or continuing the habit. Another
                                  interesting discovery was the female-specific increase in smokeless tobacco use. In the earlier years of the dataset, smokeless tobacco
                                  use was higher in male students. However, over the past few years, female students have been starting to use this tobacco product. This
                                  may call for a greater investment in gender targeted smokeless tobacco education and cessation programs. It could also be the case that
                                  e-cigarette use is lumped into the smokeless tobacco category, in which case it makes sense that this category should be increasing taking
                                  into account the boom in e-cigarette use over the last few years.',
                                  style="font-size:115%;")
                              ))
              ),
              # Second title text
              fluidRow(column(width = 8,
                              align="center",
                              offset = 2,
                              box(
                                width = 20, 
                                background = 'light-blue',
                                h1('Going Forward')
                              ))),
              # Second title body
              fluidRow(column(width = 10,
                              align="justified",
                              offset = 1,
                              box(
                                width = 20,
                                background = 'light-blue',
                                p("Going forward there are a number of additional steps I could take to improve on this tool and analysis. I didn't
                                  include any statistical testing because my main goal was to point out areas that should be investigated more closely.
                                  Performing statistical tests between different groups (cigarette vs. smokeless, male vs. female) would add to the validity
                                  of the analysis. Another interesting addition would be to produce an overall change map that shows the change in use between
                                  male and female specifically. This could show how cigarette and smokeless tobacco use by gender has changed over the last 18
                                  years. One last additional feature would be to produce regression models for each state for different categories. Although there
                                  are many states in the data that do not have sufficient points to produce a predictive model, it would be interesting to produce models
                                  for states with perhaps 15 or more years worth of data. These regressions could be plotted to give a rough estimate of
                                  what the percentage of users or quitters will be in subsequent years.",
                                  style="font-size:115%;"),
                                p('Another interesting approach to the dataset would be to inspect trends in other data. For example, how does the frequency of
                                  tobacco incidents in top grossing movies affect the level of youth tobacco usage in the following years? Or how does the state
                                  tax of tobacco product affect the level of youth tobacco usage? This data set did not mention the use of e-cigarette devices,
                                  but this is also a very interesting area and the large decrease in cigarette use could be connected to the massive uprising of
                                  e-cigarette use in the past few years.',
                                  style="font-size:115%;")
                                ))
              ))
    )
  )
))