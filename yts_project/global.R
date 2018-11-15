library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(choroplethr)
library(DT)

ms_data = read.csv('./data/ms_data.csv', stringsAsFactors = FALSE)
# Fix some troublesome values for Indiana
ms_data[ms_data$YEAR==2016 &
          ms_data$LocationAbbr=='IN' &
          ms_data$TopicDesc=='Smokeless Tobacco Use' &
          ms_data$Response=='Ever', 'Low_Confidence_Limit'] = NA
hs_data = read.csv('./data/hs_data.csv', stringsAsFactors = FALSE)
