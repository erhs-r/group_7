library(tidyverse)
library(tidycensus)

#Set your census API, I got one
census_api_key("a9f73606aa90c548c310f08b3239a72ca964a1d4")

#population by county for 2018
pltn <- get_acs(geography = "county",
              variables = c(pop = "B00001_001"),
              year = 2018)