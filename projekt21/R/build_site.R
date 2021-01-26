library(tidyverse)

build_site <- function() {
  source('R/net.R', local = T)
  source('R/build.R', local = T)
  
  config_all <- build_config()
  
  config <- config_all$data$net
  build_net()
  
  config <- config_all$data$build
  build_build()
}

build_config <- function() {
 
  # read download in config.yaml
  config <- yaml::read_yaml('config.yaml')
  
  # local directories must exist
  map_chr(config, ~ unlist(.x['path'])) %>%
    map_if(~ !is.na(.x), ~ if (!dir.exists(.x)) dir.create(.x))
  
  # get filename full path
  getfile <- function(configname) {
    c <- as.relistable(config)
    c <- unlist(c)
    tmpnams <- names(c)[grep(configname, names(c))] # location of configname
    tmpkeys <- unlist(strsplit(tmpnams,'[.]')) # delete keys after configname
    
    # configname in nested list must be on level 1 or 2
    if (length(tmpkeys)>2) warning("File in config.yaml not on level 2")

    file.path(config[[tmpkeys[1]]][['path']], c[tmpnams])
  }
  
  list(data=config, filepath=getfile)
}

writedate <- function() {
  format(Sys.time(), yaml::read_yaml('config.yaml')$dateformat)
}
