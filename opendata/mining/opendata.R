# Weekly death data in Switzerland
# Download from opendata.swiss

# library(curl::curl_download)
# library(jsonlite::fromJSON)

#"https://opendata.swiss/de/dataset?q=%22Todesfälle+nach+Fünf-Jahres-Altersgruppe%22+Kanton"

# list of all apis
openlist <- jsonlite::fromJSON('https://opendata.swiss/api/3/action/package_list')
stopifnot(openlist$success)

# give list of all ids
pivot.slug <- "todesf.*lle.*alter.*kanton.*csv"
idlist <- openlist$result[grepl(pivot.slug, openlist$result)]

# download datasets (metadata and urls) by id (slug)
pdown <- function(id) {
  myurl <- "https://opendata.swiss/api/3/action/package_show"
  
  if (!dir.exists('data')) dir.create('data')
  if (!dir.exists(file.path('data',Sys.Date()))) dir.create(file.path('data',Sys.Date()))
  myfile <- file.path('data',Sys.Date(), id)
  
  curl::curl_download(paste0(myurl,'?id=', id), myfile)
}
lapply(idlist, pdown)

