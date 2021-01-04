# Extract data from the most recent week

# return value is dataframe
extract_mrw <- function(data, vogeo = 'CH') {
  
  # most recent week
  mrw <- max(data$TIME_PERIOD)
  
  data %>% 
    filter(AGE == '_T' & SEX == 'T') %>%
    filter(GEO %in% vogeo) %>%
    filter(TIME_PERIOD == mrw)
}
