## testing functions opendata

library(dplyr)
# library(jsonlite::fromJSON)

myid <- 'todesfalle-nach-funf-jahres-altersgruppe-geschlecht-woche-und-kanton-csv-datei33'
myfile <- file.path('scrap', '2020-12-24', myid)

# shows one dataset by id (slug)
pshow <- function(id) {
  res <- jsonlite::fromJSON(id)
  stopifnot(res$success)
  return(res)
}

# give all meta information of one api
pshow(myfile) 

# shows selected metadata in a table
ptable <- function(id) {
  rest_api <- pshow(id)
  stopifnot(rest_api$success) 
  
  as.na <- function(cell) {
    ifelse(is.null(cell), NA, cell)
  }
  
  r <- rest_api$result
  api_desc <- tibble(id=id,
                     issued=r$issued,
                     author=r$author,
                     language=r$language,
                     spatial=as.na(r$spatial),
                     metadata_created=r$metadata_created,
                     metadata_modified=r$metadata_modified,
                     start_date=as.na(r$temporals$start_date),
                     end_date=as.na(r$temporals$end_date),
                     display_name=r$display_name$de,
                     state=r$state,
                     format=paste(sort(unique(r$resources$format)),collapse = ','))
  
  return(api_desc)
}

# give selected metadata of apis with pivot.slug
ptable(myfile) %>%
  filter(language=='de') %>% t

# shows selected api data in a table
papi <- function(id, formats=c('CSV'), language='de') {
  rest_api <- pshow(id)
  stopifnot(rest_api$success) 
  
  as.na <- function(cell) {
    ifelse(is.null(cell), NA, cell)
  }
  
  r <- filter(rest_api$result$resources, format %in% formats)
  #return(r)
  api_desc <- tibble(id=id,
                     issued=r$issued,
                     display_name=unlist(r$display_name[language]),
                     language=unlist(r$language),
                     created=r$created,
                     format=r$format,
                     rights=r$rights,
                     state=r$state,
                     url=r$url,
                     download_url=r$download_url,
                     revision_id=r$revision_id)
  
  return(api_desc)
}

# give selected download urls of apis with pivot.slug
y <- papi(myfile)
unlist(y[1,])
