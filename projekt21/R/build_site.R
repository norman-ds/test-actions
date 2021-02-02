library(tidyverse)
library(jsonlite)

build_site <- function() {
  source('R/net.R', local = T)
  source('R/build.R', local = T)
  source('R/events.R', local = T)
  source('R/content.R', local = T)
  
  config_all <- build_config()
  anybox <- ranybox(start=writedate())
  
  config <- config_all$data$net
  build_net()

  config <- config_all$data$build
  build_build()
  
  config <- config_all$data$events
  build_events()
  
  config <- config_all$data$content
  build_content()
  
  invisible(anybox$get())
}

build_config <- function() {
 
  # read download in config.yaml
  config <- yaml::read_yaml('config.yaml')
  
  # local directories must exist
  map_chr(config, ~ unlist(.x['path'])) %>%
    map_if(~ !is.na(.x), ~ if (!dir.exists(.x)) dir.create(.x))
  
  # get filename full path
  getfile <- function(configname) {
#    c <- unlist(as.relistable(config))
    c <- unlist(config)
    tmpnams <- names(c)[grep(configname, names(c))] # location of configname
    tmpkeys <- unlist(strsplit(tmpnams,'[.]')) # delete keys after configname
    
    # configname in nested list must be on level 1 or 2
    if (length(tmpkeys)>2) warning("File in config.yaml not on level 2")

    file.path(config[[tmpkeys[1]]][['path']], c[tmpnams])
    
  }
  
  list(data=config, filepath=getfile)
}

writedate <- function(datetime=Sys.time()) {
  format(datetime, yaml::read_yaml('config.yaml')$dateformat)
}

ranybox <- function(...) {
  
  mylist <- list(...)
  
  get <- function() {
    mylist
  }
  
  add <- function(...) {
    #mylist <<- list(...)
    mylist <<- append(mylist, list(...))
  }
  
  return(list(get=get, add=add))
}

build_site()

