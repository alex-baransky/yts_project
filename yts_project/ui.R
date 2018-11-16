shinyUI(dashboardPage(
  # Set the skin color to blue
  skin = 'blue',
  # Give a title
  dashboardHeader(title = "YTS DataVis Tool"),
  dashboardSidebar(
    sidebarMenu(
      # Create different tabs
      menuItem("Introduction", tabName = "intro", icon = icon("info")),
      menuItem("Usage Map", tabName = "usage_map", icon = icon("globe")),
      menuItem("Usage Trends", tabName = 'usage_trends', icon = icon("chart-line")),
      menuItem("Cessation Map", tabName = "cessation_map", icon = icon("globe")),
      menuItem("Cessation Trends", tabName = "cessation_trends", icon = icon("chart-line")),
      menuItem('Overall Usage Change', tabName = 'usage_diff', icon = icon("map")),
      menuItem('Overall Cessation Change', tabName = 'cessation_diff', icon = icon("map"))
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
                              align="center",
                              offset = 1,
                              box(
                                width = 20,
                                background = 'light-blue',
                                p('This is some text that introduces the user to the app and the subject.')
                              ))
              )),
      # Usage heat map tab
      tabItem(tabName = "usage_map",
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h1('United States Youth Tobacco Usage Heat Map'),
                p('Use this map to visualize areas of the US with high youth tobacco use.')
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
                align = 'center',
                # Text description
                h1('State-Level Youth Tobacco Usage Trends'),
                p('Use this graph to visualize state-level youth tobacco usage trends.')
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
                align = 'center',
                # Text description
                h1('United States Youth Tobacco Cessation Heat Map'),
                p('Use this map to visualize areas of the US with high youth tobacco cessation.')
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
                align = 'center',
                # Text description
                h1('State-Level Youth Tobacco Usage Trends'),
                p('Use this graph to visualize state-level youth tobacco usage trends.')
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
                align = 'center',
                # Text description
                h1('United States Youth Tobacco Usage Overall Change'),
                p('Use this map to visualize areas of the US with large changes in youth tobacco usage')
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
                align = 'center',
                # Text description
                h1('United States Youth Tobacco Cessation Changes Overall'),
                p('Use this map to visualize areas of the US with large changes in youth tobacco cessation.')
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
      )
    )
  )
))