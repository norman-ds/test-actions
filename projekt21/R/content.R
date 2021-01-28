build_content <- function() {
  input <- config_all$data$mainfile
  output_dir <- config_all$data$outputpath
  
  source('R/momodyfun.R', local = T)
  
  rmarkdown::render(input, output_file="index.html", output_dir=output_dir, knit_root_dir = '.')
  }


