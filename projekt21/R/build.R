build_build <- function() {
  # load function data file reader
  source('R/fileread.R', local = T)
  source('R/extract_mrw.R', local = T)
  
  # load datafile
  datafile <- config_all$filepath('datafile') %>% fileread()
  
  ##########################
  # build firstrelease.csv
  release <- config_all$filepath('releasefile')
  
  # Vector of gegrafic regions 
  datafile %>% 
    extract_mrw(config_all$data$geofilter, config$releaseweeks) %>%
    add_column(DOWNLOAD = writedate(), .before = 1) %>%
    write_csv(release, append = file.exists(release))
  
  stopifnot(file.exists(release))
  
  ##########################
  # build timeserie
  
  config_all$filepath('earlydata') %>%
    fileread() %>%
    bind_rows(datafile, .id = 'file') %>%
    filter(AGE == '_T' & SEX == 'T') %>%
    filter(GEO %in% config_all$data$geofilter) %>%
    group_by(file) %>%
    summarise(min = min(TIME_PERIOD), max = max(TIME_PERIOD))
  
  message("... build completed ...")
  
}


