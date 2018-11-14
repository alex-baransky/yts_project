library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(choroplethr)

ms_data = read.csv('./data/ms_data.csv', stringsAsFactors = FALSE)
hs_data = read.csv('./data/hs_data.csv', stringsAsFactors = FALSE)
