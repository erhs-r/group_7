library(tidyverse)
library(tidycensus)
library(fuzzyjoin)

#Set your census API, I got one
census_api_key("a9f73606aa90c548c310f08b3239a72ca964a1d4")

#population by county for 2018
pltn <- get_acs(geography = "county",
                variables = c(pop = "B00001_001"),
                year = 2018)

rcases <- read.csv("raw-data/covidcases.csv")

rcases$ncnty <- paste(rcases$county, rcases$state, sep = " County, ")
cases_by_county <- rcases %>% 
  group_by(ncnty) %>% 
  summarize(total = last(cases))

colnames(pltn)[2] <- "ncnty"
cases_by_county$ncnty <- as.character(cases_by_county$ncnty)
pltn$ncnty <- as.character(pltn$ncnty)

cases_pop_county <- pltn %>% 
  inner_join(cases_by_county, by = "ncnty") 


cases_pop_county$casepercap <- (cases_pop_county$total / cases_pop_county$estimate * 100000)
cases_pop_county <- cases_pop_county %>% 
  separate(ncnty, 
           into = c("county", "state"),
           sep = " County, ")
