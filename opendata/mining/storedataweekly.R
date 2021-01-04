# Store the most recent weeks data
# Stors only a few marker
library(tidyverse)
source('digdata.R')
source('fileread.R')
source('extract_mrw.R')

# select a vector of json files
vofiles <- list.files("scrap", pattern = "csv", all.files = T, full.names = T, recursive = T, no.. = T)

# function of selected dates of json file
pivotfile <- function(jfile) {
  list(start_date = as.Date(jfile$temporals$start_date, format="%Y-%m-%d"),
       end_date = as.Date(jfile$temporals$end_date, format="%Y-%m-%d"),
       url = jfile$resources$download_url[jfile$resources$format=='CSV'])
}

# create a dataframe of file, url and dates
df_files <- vofiles %>%
  purrr::map_dfr(function(x){df <- digdata(x) %>% pivotfile; df$file=x; df}) 

# function of find url of the most recent week
file_of_mrw <- function(data, unique_url = TRUE ) {
  df_red <- data %>%
    filter(end_date == max(end_date))
  
  if (!unique_url) {
    return(df_red)
  } else {
    myfile <- unique(df_red$url)
    stopifnot(length(myfile) == 1)
    return(myfile)
  }
}

# 'dirstore' must be present as a local directory
dirstore <- 'store'
if (!dir.exists(dirstore)) dir.create(dirstore)
newfile <- paste0(file.path(dirstore, Sys.Date()),'.csv')
stopifnot(!file.exists(newfile))

# download data
tmp <- 'tmpdata.csv'
if (file.exists(tmp)) unlink(tmp)

df_files %>%
  file_of_mrw() %>%
  curl::curl_download(tmp)

# Vector of gegrafic regions 
vogeo <- c('CH', 'CH011', 'CH021', 'CH040', 'CH070')
fileread(tmp) %>% 
  extract_mrw(vogeo) %>%
  write.csv(newfile)

unlink(tmp)
stopifnot(file.exists(newfile))

