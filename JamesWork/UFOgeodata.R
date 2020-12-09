library("tidyverse")
library("ggmap")
library("readxl")
library("tidygeocoder")
library("revgeo")
library("ggmap")
library("maps")  


### DO NOT RUN THIS CODE UNLESS YOU HAVE TO, WILL TAKE HOURS
### The final output was written as a csv in raw-data "ufo2019counties"
### This code is designed to assign latitude, longitude and counties to our ufo data

ufo <- read_excel("raw-data/ufo2019.xlsx")

ufogeo <- geo(city=ufo$City, state = ufo$State, method = "osm")

ufo <-ufo %>% 
  mutate(lat = ufogeo$lat, long = ufogeo$long)

head(ufo)

ufofilter <-  drop_na(ufo)

ufocounty <-map.where(database="county", 
                 ufofilter$long, ufofilter$lat)

ufofinal <- ufofilter %>% 
  mutate(county = ufocounty)

write.csv(ufofinal, file = "ufo2019counties")

