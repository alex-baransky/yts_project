shinyUI(dashboardPage(
  # Set the skin color to blue
  skin = 'blue',
  # Give a title
  dashboardHeader(title = "YTS DataVis Tool"),
  dashboardSidebar(
    sidebarMenu(
      # Create different tabs
      menuItem("Introduction", tabName = "intro", icon = icon("info")),
      menuItem("Heat Map", tabName = "map", icon = icon("map")),
      menuItem("State Trends", tabName = 'trends', icon = icon("chart-line")),
      menuItem("Monthly Change", tabName = "change", icon = icon("bar-chart-o")),
      menuItem("Data Table", tabName = "data", icon = icon("database"))
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
                                h3('Created by: Alex Baransky')
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
      # Heat map tab
      tabItem(tabName = "map",
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h1('United States Tobacco Use Heat Map'),
                p('Use this map to visualize areas of the US with high youth tobacco use.')
              )),
              fluidRow(box(
                # Widgets
                column(
                  selectInput('map_year', 'Choose a year:', choices=unique(ms_data$YEAR)[order(unique(ms_data$YEAR), decreasing = TRUE)]),
                  selectInput('map_response', 'Choose a habit:', choices=unique(ms_data$Response), selected = 'Current'),
                  width = 6
                ),
                column(
                  radioButtons('map_measure', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
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
                h3(textOutput('map_text'))
              )),
              # Plotly overall map output
              fluidRow(box(plotlyOutput("overall_map"), width = 12)),
              fluidRow(
                # Male map
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('male_map')
                ), width = 6),
                # Female map
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('female_map')
                ), width = 6))
              # # Male map output
              # fluidRow(box(plotlyOutput("male_map"), width = 12)),
              # # Female map output
              # fluidRow(box(plotlyOutput("female_map"), width = 12))
              ),
      # State trend tab
      tabItem(tabName = 'trends',
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h1('State-Level Youth Tobacco Use Trends'),
                p('Use this graph to visualize state-level youth tobacco use trends.')
              )),
              # Widgets
              fluidRow(box(
                selectInput('trend_state', 'Choose a state:', choices=unique(ms_data$LocationDesc)[order(unique(ms_data$LocationDesc))]),
                radioButtons('trend_measure', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
                width = 12
              )),
              # Graph title
              fluidRow(box(
                background = 'light-blue',
                width = 12,
                align = 'center',
                # Text description
                h3(textOutput('trend_text'))
              )),
              # Overall graph
              fluidRow(box(plotlyOutput('overall_trend'), width = 12)),
              fluidRow(
                # Male graph
                column(box(
                  background = 'light-blue',
                  width = 12,
                  plotlyOutput('male_trend')
                ), width = 6),
                # Female graph
                column(box(
                  background = 'maroon',
                  width = 12,
                  plotlyOutput('female_trend')
                ), width = 6))
              ),
      tabItem(tabName = 'change',
              fluidRow(box(plotOutput("change"), width = 12)),
              fluidRow(htmlOutput('select_state'))),
      tabItem(tabName = "data",
              fluidRow(box(DT::dataTableOutput("county_table"), width = 12, title = 'Observations by County')),
              fluidRow(box(DT::dataTableOutput("time_table"), width = 12, title = 'Observations by Time')))
    )
  )
))