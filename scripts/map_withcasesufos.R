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
library(raster)
cases_pop_county <- read.csv("raw-data/counties_pop_casew.csv")
ufo <- read.csv("raw-data/ufo_withlatlong.csv")
USA <- getData("GADM", country = "usa", level = 2)

popup_dat <- paste0("<strong>County: </strong>", 
                    cases_pop_county$county, 
                    "<br><strong>Cases Per Capita: </strong>", 
                    cases_pop_county$casepercap)

pal <- colorQuantile("YlOrRd", NULL, n = 10)
leaflet() %>% 
  addTiles() %>% 
  fitBounds(-102.03,37,-109.03, 41) %>% 
  addTiles() %>% 
  addPolygons(data = USA,
              fillColor = ~pal(cases_pop_county$casepercap), 
              fillOpacity = 0.6, 
              color = "#BDBDC3", 
              weight = 1,
              popup = popup_dat) %>% 
  
  addCircleMarkers(ufo$lon, 
                   ufo$lat, 
                   radius = 5, 
                   fill = T,
                   fillOpacity = 0.2,
                   opacity = 0.6) %>% 
  addLegend(position = "bottomleft", pal = pal, values = cases_pop_county$casepercap,
            title = "Cases per Capita",
            opacity = 1)

  