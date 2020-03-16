# This is an example of how to make an API request to the ET portal using R.

#	Valid lessee names:
#	All%20Lessee
#	Cox
#	Deconinck%201
#	Deconinck%202
#	Hayday%201
#	Hayday%202
#	River%20Valley%20Ranch
#	Noroian
#	Quail%20Mesa
#	Red%20River
#	Underwood%20MSCP

library(httr) # API tools for R
library(tidyverse)
httr::set_config(httr::config(ssl_verifypeer=0L)) # get around the firewall

url <- 'https://mwdmetric1.westus.cloudapp.azure.com//METRICPortal/api/zonal-statistics/csv' # only include the url before the ? symbol

rawdata <- GET(url, query = list(from     = '2015-01-01',  # make a GET request
                                 to       = '2015-12-31',
                                 user     = 'Lauren',
                                 password = 'Metro*2585'))

cat(paste("API status: ", http_status(rawdata)$message), "\n")
etdata <- content(rawdata, type='text/csv')  # decode the raw data and parse it into an R dataframe

sum(etdata$DailyET)

etdata %>% filter(Parcel == 621013) %>% ggplot(aes(x = Date, y = DailyET)) + geom_col()

