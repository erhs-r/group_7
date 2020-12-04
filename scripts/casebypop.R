library(tidyverse)
library(tidycensus)
library(fuzzyjoin)

#Set your census API, I got one
census_api_key("a9f73606aa90c548c310f08b3239a72ca964a1d4")

#population by county for 2018
pltn <- get_acs(geography = "county",
                variables = c(pop = "B00001_001"),
                year = 2018)

cases <- read.csv("raw-data/covidcases.csv")

cases_by_county <- cases %>% 
  group_by(county) %>% 
  summarise(total = sum(cases))

cases_by_county$county <- as.character(cases_by_county$county)
pltn$NAME <- as.character(pltn$NAME)

cases_pop_county <- pltn %>% 
  regex_inner_join(cases_by_county, by = c(NAME = "county")) 

cases_pop_county <- cases_pop_county %>% 
  inner_join(cases, by="county")
cases_pop_county <- cases_pop_county[!duplicated(cases_pop_county$county),]
cases_pop_county <- cases_pop_county[,c(4:6,9)]
colnames(cases_pop_county)[c(1,3)] <- c("population", "cases")

ufo <- readxl::read_excel("raw-data/ufo2019.xlsx")
ufo <- ufo %>% 
  filter(!str_detect(string = City, pattern = "Canada"))
ufo$citysta <- paste(ufo$City, ufo$State, sep = ", ") 
ufo$position <- map(ufo$citysta, ggmap::geocode)
ufo2 <- ufo %>% unnest(cols = "position")
write.csv(ufo2, file = "raw-data/ufo_withlatlong.csv")

