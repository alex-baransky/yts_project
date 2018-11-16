library(dplyr)

# This script is used to produce a new csv file that consists entirely of the percentage difference between
# reported percentages for the earliest and most recent year for each state for different categories. For example,
# what was the percentage change in students in Mississippi who want to quit over the entire range of available data?

##################################################################################################
###################### This section will be repeated for Middle School data ######################
##################################################################################################

# Load High School data
hs_data = read.csv('./hs_data.csv', stringsAsFactors = FALSE)

# Remove rows where Data_Value is NA
hs_data = hs_data[!is.na(hs_data$Data_Value),]

# Split data into cessation and usage
cessation = hs_data[hs_data$TopicDesc == 'Cessation',]
usage = hs_data[hs_data$TopicDesc != 'Cessation',]

#################################################################
####### This section will be repeated for usage dataframe #######
#################################################################
# Find max year for different categories
cessation_max = cessation %>% 
  group_by(Gender, LocationDesc, MeasureDesc) %>% 
  summarise(YEAR = max(YEAR))

# Find min year for different categories
cessation_min = cessation %>% 
  group_by(Gender, LocationDesc, MeasureDesc) %>% 
  summarise(YEAR = min(YEAR))

# Join with original data to get the Data_Value associated with min and max years
cessation_min = merge(cessation, cessation_min, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc'))
cessation_max = merge(cessation, cessation_max, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc'))

# Select relevant columns and rename columns that will be duplicate when joining
cessation_min = cessation_min %>% select(Gender, min_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, min_value=Data_Value)
cessation_max = cessation_max %>% select(Gender, max_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, max_value=Data_Value)

# Join min and max dataframes so each row has min and max year's Data_Value
cessation_total = merge(cessation_min, cessation_max, by = c('Gender', 'LocationDesc', 'MeasureDesc'))

# Create new column, diff, that is the percentage change between the min and max year
cessation_total$diff = with(cessation_total, round(((max_value - min_value)/min_value)*100, 2))
cessation_total$Response = NA
#################################################################
#################################################################

# Repeat operations for usage data, see above for comments on different operations

usage_max = usage %>% 
  group_by(Gender, LocationDesc, MeasureDesc, Response) %>% 
  summarise(YEAR = max(YEAR))

usage_min = usage %>% 
  group_by(Gender, LocationDesc, MeasureDesc, Response) %>% 
  summarise(YEAR = min(YEAR))

usage_min = merge(usage, usage_min, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc', 'Response'))
usage_max = merge(usage, usage_max, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc', 'Response'))

usage_min = usage_min %>% select(Gender, min_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, Response, min_value=Data_Value)
usage_max = usage_max %>% select(Gender, max_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, Response, max_value=Data_Value)

usage_total = merge(usage_min, usage_max, by = c('Gender', 'LocationDesc', 'MeasureDesc', 'Response'))

usage_total$diff = with(usage_total, round(((max_value - min_value)/min_value)*100, 2))

# Create full dataframe by row binding the two separate parts
hs_diff = rbind(cessation_total, usage_total)

# Cap infinite values at 100 and -100, this will allow app users to see that there was a major increase or decrease
hs_diff$diff = with(hs_diff, ifelse(diff == Inf, 100, ifelse(diff == -Inf, -100, diff)))

# Add a columns with hover information for map
hs_diff$hover = with(hs_diff, paste(LocationDesc, '<br>',
                                    'Year Range', paste(min_year, max_year, sep=' - '), '<br>',
                                    'Value Change', paste(min_value, max_value, sep=' to ')))

# Remove some unnecessary columns and rename LocationAbbr.x
hs_diff = hs_diff %>% 
  select(-LocationAbbr.y, LocationAbbr=LocationAbbr.x)
##################################################################################################
##################################################################################################

# Repeat entire above chunk for Middle School data, see above for comments on different operations

ms_data = read.csv('./ms_data.csv', stringsAsFactors = FALSE)

ms_data = ms_data[!is.na(ms_data$Data_Value),]

cessation = ms_data[ms_data$TopicDesc == 'Cessation',]
usage = ms_data[ms_data$TopicDesc != 'Cessation',]

cessation_max = cessation %>% 
  group_by(Gender, LocationDesc, MeasureDesc) %>% 
  summarise(YEAR = max(YEAR))

cessation_min = cessation %>% 
  group_by(Gender, LocationDesc, MeasureDesc) %>% 
  summarise(YEAR = min(YEAR))

cessation_min = merge(cessation, cessation_min, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc'))
cessation_max = merge(cessation, cessation_max, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc'))

cessation_min = cessation_min %>% select(Gender, min_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, min_value=Data_Value)
cessation_max = cessation_max %>% select(Gender, max_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, max_value=Data_Value)

cessation_total = merge(cessation_min, cessation_max, by = c('Gender', 'LocationDesc', 'MeasureDesc'))

cessation_total$diff = with(cessation_total, round(((max_value - min_value)/min_value)*100, 2))
cessation_total$Response = NA

usage_max = usage %>% 
  group_by(Gender, LocationDesc, MeasureDesc, Response) %>% 
  summarise(YEAR = max(YEAR))

usage_min = usage %>% 
  group_by(Gender, LocationDesc, MeasureDesc, Response) %>% 
  summarise(YEAR = min(YEAR))

usage_min = merge(usage, usage_min, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc', 'Response'))
usage_max = merge(usage, usage_max, by = c('Gender', 'YEAR', 'LocationDesc', 'MeasureDesc', 'Response'))

usage_min = usage_min %>% select(Gender, min_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, Response, min_value=Data_Value)
usage_max = usage_max %>% select(Gender, max_year=YEAR, LocationDesc, LocationAbbr, MeasureDesc, Response, max_value=Data_Value)

usage_total = merge(usage_min, usage_max, by = c('Gender', 'LocationDesc', 'MeasureDesc', 'Response'))

usage_total$diff = with(usage_total, round(((max_value - min_value)/min_value)*100, 2))

ms_diff = rbind(cessation_total, usage_total)

ms_diff$diff = with(ms_diff, ifelse(diff == Inf, 100, ifelse(diff == -Inf, -100, diff)))

ms_diff$hover = with(ms_diff, paste(LocationDesc, '<br>',
                                    'Year Range', paste(min_year, max_year, sep=' - '), '<br>',
                                    'Value Change', paste(min_value, max_value, sep=' to ')))

ms_diff = ms_diff %>% 
  select(-LocationAbbr.y, LocationAbbr=LocationAbbr.x)

# Rename MeasureDesc non-cessation categorical values so they mimic those in TopicDesc
ms_diff[ms_diff$MeasureDesc == 'Smoking Status', 'MeasureDesc'] = 'Cigarette Use'
ms_diff[ms_diff$MeasureDesc == 'User Status', 'MeasureDesc'] = 'Smokeless Tobacco Use'

hs_diff[hs_diff$MeasureDesc == 'Smoking Status', 'MeasureDesc'] = 'Cigarette Use'
hs_diff[hs_diff$MeasureDesc == 'User Status', 'MeasureDesc'] = 'Smokeless Tobacco Use'

####### End data cleaning #######

# Write High School and Middle School dataframes to csv files

write.csv(hs_diff, './hs_diff.csv', row.names = FALSE)
write.csv(ms_diff, './ms_diff.csv', row.names = FALSE)

