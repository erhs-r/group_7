library(flexdashboard)
library(readr)
library(lubridate)
library(shiny)
library(jsonlite)
library(maptools)
library(ggplot2)
library(tidyr)
library(dplyr)
library(purrr)
library(leaflet)
library(plotly)
library(DT)
library(ggthemes)
library(viridis)
library("tidyverse")

### This script is designed to create the data table for our flex dashboard.
### It is a table of all the Covid Deaths. It is included to remind us of everyone that has passed due 
### to this pandemic. 

covid <- read_csv("JamesWork/covidcases.csv")

covid <- covid %>% 
  select(-fips, -cases) %>% 
  filter(deaths == 1)%>% 
  select(-deaths)



### This code chunk works better when knit into flexdashboard

datatable(covid, 
          colnames = c("Date", "County", "State"), 
          extensions = "Scroller", style="bootstrap", 
          class="compact", width="100%", 
          options=list(deferRender=TRUE, scrollY=300, scroller=TRUE))
