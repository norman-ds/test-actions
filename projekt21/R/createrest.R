# ouput file ist restfile
rfile <- config_all$filepath('restfile') 
robject <- rfile %>% restful()

# input files
input <- list(path='net', pattern="todesf.*lle.*alter.*kanton.*csv")

# function of selected fieldes out of json file
pivotfile <- function(jfile) {
  list(display_name = jfile$display_name$de,
       created = jfile$issued,
       format = 'CSV',
       start_date = as.Date(jfile$temporals$start_date, format="%Y-%m-%d"),
       end_date = as.Date(jfile$temporals$end_date, format="%Y-%m-%d"),
       download_url = jfile$resources$download_url[jfile$resources$format=='CSV'])
}

# create a dataframe of file, url and dates
list.files(path = input$path,
  pattern = input$pattern, all.files = T, full.names = T, recursive = F, no.. = T) %>%
  purrr::map(~ jwrapper(.x)) %>% 
  purrr::map_df(~ pivotfile(.x)) %>%
  arrange(desc(end_date)) %>% 
  robject$init()

robject$write()
stopifnot(file.exists(rfile))

