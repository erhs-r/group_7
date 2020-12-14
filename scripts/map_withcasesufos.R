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

temp <- merge(USA, cases_pop_county,
              by.x = c("NAME_1", "NAME_2"), by.y = c("state", "county"),
              all.x = TRUE)

popup_dat <- paste0("<strong>County: </strong>", 
                    temp$NAME_2, 
                    "<br><strong>Cases Per 100,000: </strong>", 
                    floor(temp$casepercap))

popup_ufo <- paste0("<strong>Description: </strong>", 
                      ufo$Description)

pal <- colorNumeric(
  palette = "YlOrRd",
  n = 10,
  domain = temp$casepercap)
pal <- colorQuantile("YlOrRd", NULL, n = 10)
leaflet() %>% 
  addTiles() %>% 
  fitBounds(-102.03,37,-109.03, 41) %>% 
  addTiles() %>% 
  addPolygons(data = temp,
              fillColor = ~pal(temp$casepercap), 
              fillOpacity = 0.6, 
              color = "#BDBDC3", 
              weight = 1,
              popup = popup_dat) %>% 
  addMarkers(ufo$lon, 
             ufo$lat, 
             clusterOptions = markerClusterOptions(),
             icon = makeIcon("alien.png"),
             popup = popup_ufo) %>% 
  addLegend(position = "bottomleft", pal = pal, values = cases_pop_county$casepercap,
            title = "Cases per 100,000",
            opacity = 1,)
