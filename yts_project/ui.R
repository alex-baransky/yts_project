shinyUI(dashboardPage(
  # Set the skin color to blue
  skin = 'blue',
  # Give a title
  dashboardHeader(title = "YTS Data Inspection"),
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
              fluidRow(column(8, align="center", offset = 2,
                              box(htmlOutput('intro_header'), htmlOutput('intro_author'), width = 20, 
                                  background = 'light-blue'),
                              tags$style(type="text/css", "#string { text-align:center }"))),
              fluidRow(column(10, align="center", offset = 1,
                              box(htmlOutput('intro_body1'), div(img(src="range_map.jpg", height=350, width=350)),
                                  htmlOutput('intro_body2'), htmlOutput('intro_body3'), htmlOutput('intro_body4'), width = 20, background = 'light-blue'),
                              tags$style(type="text/css", "#string { text-align:justified }")))
      ),
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
                  selectInput('map_year', 'Choose a year:', choices=unique(ms_data$YEAR)[order(unique(ms_data$YEAR))]),
                  radioButtons('map_measure', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
                  width = 6
                ),
                column(
                  selectInput('map_response', 'Choose a habit:', choices=unique(ms_data$Response), selected = 'Current'),
                  selectInput('map_gender', 'Choose a gender:', choices=unique(ms_data$Gender)),
                  width = 6
                ),
                width = 12
              )),
              # Plotly map output
              fluidRow(box(plotlyOutput("map"), width = 12))
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
                selectInput('trend_state', 'Choose a state:', choices=unique(ms_data$LocationAbbr)[order(unique(ms_data$LocationAbbr))]),
                radioButtons('trend_measure', 'Choose a category:', choices=c('Cigarette Use', 'Smokeless Tobacco Use')),
                width = 12
              )),
              # Overall graph
              fluidRow(box(plotlyOutput('overall_trend'), width = 12)),
              fluidRow(
                column(box(
                  width = 12,
                  plotlyOutput('male_trend')
                ), width = 6),
                column(box(
                  width = 12,
                  plotlyOutput('female_trend')
                ), width = 6)
              )),
      tabItem(tabName = 'change',
              fluidRow(box(plotOutput("change"), width = 12)),
              fluidRow(htmlOutput('select_state'))),
      tabItem(tabName = "data",
              fluidRow(box(DT::dataTableOutput("county_table"), width = 12, title = 'Observations by County')),
              fluidRow(box(DT::dataTableOutput("time_table"), width = 12, title = 'Observations by Time')))
    )
  )
))