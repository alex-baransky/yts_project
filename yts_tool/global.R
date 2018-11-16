library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(choroplethr)

# Load Middle School data
ms_data = read.csv('./data/ms_data.csv', stringsAsFactors = FALSE)
# Replace empty string in Response with NA
ms_data[ms_data$Response == '', 'Response'] = NA
# Fix some troublesome Low_Confidence_Limit values for Indiana
ms_data[ms_data$YEAR==2016 &
          ms_data$LocationAbbr=='IN' &
          ms_data$TopicDesc=='Smokeless Tobacco Use' &
          ms_data$Response=='Ever', 'Low_Confidence_Limit'] = NA

# Load High School data
hs_data = read.csv('./data/hs_data.csv', stringsAsFactors = FALSE)
# Replace empty string in Reponse with NA
hs_data[hs_data$Response == '', 'Response'] = NA

# Load High School and Middle School diff data
ms_diff = read.csv('./data/ms_diff.csv', stringsAsFactors = FALSE)
hs_diff = read.csv('./data/hs_diff.csv', stringsAsFactors = FALSE)