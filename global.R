# loading required packages
library(shiny)
library(dplyr)
library(magrittr)
library(ggplot2)
library(janitor)
library(stringr)
library(readr)
library(purrr)
library(DT)

# set working directory to location contain MetData files
setwd("C:/Users/conor/OneDrive/Documents/Data Analytics Masters/Stage 2/Trimester 3/Adv Data Programming with R/Assignment 2/MetData")

##### Loading data

# loading data in global script to access it in ui and server scripts
# creating empty tibble
data <- as_tibble(list())

# loading data files and merging into overall dataframe
for (file in list.files("MetData")) {
  if (grepl(".csv",file)) {
    # creating a name variable to use as a source station
    source_station <- substr(file,1,str_locate(file,"\\.")-1) %>%
      tolower() %>%
      str_replace("-"," ")
    # creating temp dataframe to store each file
    temp <- read_csv(paste0("MetData/",file),
                     col_names = TRUE,
                     skip = 24) %>%
      # cleaning column names to ensure consistency between files
      clean_names("snake") %>%
      # creating source station variable
      mutate(Source_Station = source_station)
    # using bind_rows function to merge into one dataframe
    data %<>% bind_rows(temp)
  }
}

##### Data Cleansing

# merging g_rad and glorad variables into g_rad
data <- data %>% 
  # merging values into new g_rad variable
  mutate(g_rad = case_when(is.na(g_rad) ~ glorad,
                           TRUE ~ g_rad)) %>%
  # converting date column to datetime variable
  mutate(date = as.Date(date,"%d-%b-%Y")) %>% 
  # deleting glorad & dos columns (dos column only present in dub airport data)
  select(-glorad,-dos) %>% 
  relocate(rain,maxtp,mintp,gmin,soil,wdsp,hm,ddhm,hg,cbl,sun,g_rad,pe,evap,
           smd_wd,smd_md)

