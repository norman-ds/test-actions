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
(idlist <- openlist$result[grepl(pivot.slug, openlist$result)])

# 'data' must be present as a local directory
if (!dir.exists('data')) dir.create('data')

# download datasets (metadata and urls) by id (slug)
pdown <- function(id) {
  mydown <- FALSE
  myurl <- paste0("https://opendata.swiss/api/3/action/package_show",'?id=', id)
  lastfile <- file.path('data', id)
  newdir <- file.path('data', Sys.Date())
  

  # download the first time 
  if (!file.exists(lastfile)) {
    if (!dir.exists(newdir)) 
      dir.create(newdir)
    myfile <- file.path(newdir, id)
    
    curl::curl_download(myurl, myfile)
    file.copy(myfile, lastfile)
    cat(paste(id, 'downloaded\n'))
    mydown <- TRUE
  } 
  
  # next download
  else {
    tmp <- tempfile(id)
    curl::curl_download(myurl, tmp)
    
    # only save file if not equal
#    if (!all.equal(readLines(lastfile, warn = F), readLines(tmp, warn = F))) {
    if (!identical(jsonlite::fromJSON(lastfile), jsonlite::fromJSON(tmp))) {
      if (!dir.exists(newdir)) 
        dir.create(newdir)
      myfile <- file.path(newdir, id)
      
      file.copy(tmp, myfile)
      file.copy(myfile, lastfile)
      cat(paste(id, 'downloaded\n'))
      mydown <- TRUE
    } else {
      cat(paste(id, 'not stored\n'))
    }
    
    unlink(tmp)
    mydown
  }
    
}
lapply(idlist, pdown)

