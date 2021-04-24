library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(tidyverse)
library(stringr)
library(data.table)
library(plotly)
library(ggplot2)
library(scales)

options(scipen=999)

censusdata <- read_csv('data/census_full.csv')
floods <- read_csv('data/floods.csv')

#Sorts the census data alphabetically by state and then county so as to display correctly in the UI dropdown lists
censusdata <- censusdata %>%
  arrange(state, county)

floods <- floods %>%
  arrange(State, County, Year) %>%
  mutate(Year = as.integer(Year),
         Damage_Nominal = as.integer(Damage_Nominal),
         CPI = as.integer(CPI),
         Damage_CPIAdj = as.integer(Damage_CPIAdj))

floods <- as.data.table(floods)
censusdata <- as.data.table(censusdata)

#This section prepares the censusdata df for merging with the floods df
new_cols <- c("state_fips", "county_fips", "1996", "1997", "1998", 
              "1999", "state", "county", "2000", "2001", "2002", 
              "2003", "2004", "2005", "2006", "2007", "2008", 
              "2009", "2010", "2011", "2012", "2013", "2014", 
              "2015", "2016", "2017", "2018", "2019")

colnames(censusdata) <- new_cols

#Melt versus mutate? 
censusdata <- melt(censusdata, measure.vars = c("1996", "1997", "1998", 
                                                "1999", "2000", "2001", "2002", 
                                                "2003", "2004", "2005", "2006", "2007", "2008", 
                                                "2009", "2010", "2011", "2012", "2013", "2014", 
                                                "2015", "2016", "2017", "2018", "2019"), 
                   value.name = "Population", variable.name = 'Year')

#setorder(censusdata, state, county, Year)

#Had to write some weird code since R wanted to assign 1996 as a base year 1...
disasters <- merge(censusdata[,.(state = as.character(state),
                                    county = as.character(county),
                                    Year = as.integer(as.character(Year)),
                                    Population)],
                      floods[,.(State = as.character(State),
                                 County = as.character(County),
                                 Year = as.integer(Year),
                                 Damage_CPIAdj)],
                      by.x = c('state', 'county', 'Year'),
                      by.y = c('State', 'County', 'Year'))

disasters <- disasters %>% 
  mutate(State = state, County = county) %>% 
  arrange(State, County, Year) %>% 
  group_by(State, County, Year) %>%
  summarise(Population = mean(Population), `Total Damage` = sum(Damage_CPIAdj)) %>%
  mutate(`Population Change` = Population - shift(Population, 1, type = 'lag'), 
         `Expected Damage` = shift(`Total Damage`, 
                                   1, type = 'lag') * Population / shift(Population, 
                                                                         1, type = 'lag'),
         `Resiliency Factor` = (shift(`Total Damage`, 
                                      1, type = 'lag')
                                * Population / shift(Population, 
                                                     1, type = 'lag')) / `Total Damage`) %>%
  rename(`Affected Population` = Population, 
         `Affected Population Change` = `Population Change`)

write.csv('data/disasters.csv', row.names = FALSE)

#Creates a variable tibble of states for use in the UI
state_choices <- censusdata %>% 
  distinct(state) %>% 
  deframe()

