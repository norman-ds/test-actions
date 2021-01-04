# Extract data from the most recent week
library(tidyverse)
source('digdata.R')
source('fileread.R')
source('extract_mrw.R')

myid <- 'todesfalle-nach-funf-jahres-altersgruppe-geschlecht-woche-und-kanton-csv-datei34'
myfile <- file.path('scrap',  myid)

download_csv <- function(jfile) {
  jfile$resources$download_url[jfile$resources$format=='CSV']
}

tmp <- 'tmpdata.csv'
if (file.exists(tmp)) unlink(tmp)

myfile %>%
  digdata() %>%
  download_csv() %>%
  curl::curl_download(tmp)

fileread(tmp) %>% glimpse()
max(fileread(tmp)$TIME_PERIOD)

fileread(tmp) %>% extract_mrw()

# Vector of gegrafic regions
vogeo <- c('CH', 'CH011', 'CH021', 'CH040', 'CH070')
fileread(tmp) %>% extract_mrw(vogeo)

unlink(tmp)
