library("tidyverse")
library("ggthemes")
library("usmap")
library("ggmap")
library("maps")
library("readxl")
library("ggrepel")
library("gridExtra")


###This script is for a side-by-side scatterplot of covid cases by state

# Read in data
covidbycounty <- read_csv("JamesWork/counties_pop_casew.csv") 
covid <- read_csv("JamesWork/covidcases.csv")
ufobycounty <- read_csv("JamesWork/ufo2019counties") 

#isolated county, but couldnt get fips to work so stopped
#dont think county will be great anyway, too few data points compared to counties
ufobycounty<- drop_na(ufobycounty)
justcounty <- gsub(".*,","",ufobycounty$county)

ufobycounty <- ufobycounty %>% 
  mutate(County = justcounty) %>% 
  select(-county)

#prepared data

ufobystate <- ufobycounty %>% 
  group_by(State) %>% 
  count() %>% 
  ungroup()

ufobystate <- mutate(.data = ufobystate, state_name = c("Alabama", "Arizona", 
                                          "Arkansas", "California", "Colorado", 
                                          "Connecticut", "Delaware", 
                                          "Florida", "Georgia","Idaho", 
                                          "Illinois", "Indiana", "Iowa", "Kansas", 
                                          "Kentucky", "Louisiana", "Maine", 
                                          "Maryland", "Massachusetts", "Michigan", 
                                          "Minnesota",
                                          "Mississippi", "Missouri", "Montana", 
                                          "Nebraska", "Nevada", "New Hampshire", 
                                          "New Jersey", "New Mexico", "New York", 
                                          "North Carolina", "North Dakota",
                                          "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
                                          "Rhode Island", "South Carolina", "South Dakota", 
                                          "Tennessee", "Texas","Utah", "Vermont", 
                                          "Virginia", "Washington", "West Virginia", 
                                          "Wisconsin", "Wyoming"))

covidbystate <- covid %>% 
  group_by(state) %>% 
  count() %>% 
  ungroup() 

covidbystate <- covidbystate[-c(2, 9, 12, 13, 37, 42, 50),]

statepopulations <- read_excel("JamesWork/Statepopulations.xlsx")

ufoandcovid <- ufobystate %>%
  mutate(covid_cases = covidbystate$n) %>% 
  mutate(ufo_sightings = ufobystate$n) %>% 
  mutate(population = statepopulations$Population) %>% 
  mutate(covid_per_cap = covid_cases/population) %>% 
  mutate(ufo_per_cap = ufo_sightings/population)

##ggplots with data

plotone <- ufoandcovid %>% 
ggplot(aes(x=ufo_sightings, y = covid_cases)) +
  geom_point() +
  geom_text_repel(label = ufoandcovid$State, size = 2) +
  labs(x = "UFO sightings", y = "Covid cases", 
       title = "2020 Covid cases by 2019 UFO sightings in the lower 48 states (per capita on right)")+
  theme_tufte()

plottwo <- ufoandcovid %>% 
  ggplot(aes(x=ufo_per_cap, y = covid_per_cap)) +
  geom_point() +
  geom_text_repel(label = ufoandcovid$State, size = 2) +
  labs(x = "UFO sightings per capita", y = "Covid Cases per capita")+
  theme_tufte() +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
        axis.text.y = element_blank())

##final product

final_plot <- grid.arrange(plotone, plottwo, ncol = 2)

