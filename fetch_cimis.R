### CIMIS Data Import
### Lauren Steely, MWD
### February 2017, updated August 2019

# Defines function fetch_cimis(), which downloads daily CIMIS data using the web API
# for a specified period, for the specified stations, and returns the data as a
# tidy data frame. Requires an API key (a character string) which can be
# obtained from the CIMIS website after registering.

# stations  : one station ID as numeric, or multiple stations as a comma-separated string
# dataitems : comma-separated string (list of items here: https://et.water.ca.gov/Rest/Index)
# startdate : start of time range; a string formatted as "YYYY-MM-DD"
# enddate   : end of time range; a string formatted as "YYYY-MM-DD"
# units     : 'E' for imperial units or 'M' for metric units (optional; defaults to E)
# key       : an API key obtained from the CIMIS website; character string

# Example usage:
# cimisdata <- fetch_cimis(151, '2015-01-01', '2016-12-31', 'M', '5e0d7efd-76fb-4c82-9437-3331ba5b07b0')
# cimisdata <- fetch_cimis('151, 131', '2015-01-01', '2016-12-31', '5e0d7efd-76fb-4c82-9437-3331ba5b07b0')

require(httr)   # access web APIs
require(jsonlite)

defaultkey <- '5e0d7efd-76fb-4c82-9437-3331ba5b07b0'
defaultdataitems <- 'day-air-tmp-avg, day-precip, day-eto'

# Define a simple recursive function that will help later when dealing with NULL vals
simple_rapply <- function(x, fn)
{
  if (is.list(x)) lapply(x, simple_rapply, fn)
  else fn(x)
}

# Download CIMIS data. We use httr's <GET> function. The API seems to have a data limit for a single request (if too big it will return http status 400) so we will have to add extra processing for longer date ranges, downloading in  date-range batches. The response is returned as a JSON object and stored as r1. If successful, http_status(r) will return code "200".

fetch_cimis <- function(stations, dataitems = defaultdataitems, startdate, enddate, units = 'E',
                        key = defaultkey) {

  stations <- as.character(stations)

  cat("Downloading CIMIS data...", "\n")
  r1 <- GET("http://et.water.ca.gov/api/data",
            query = list("appKey"        = key,
                         "targets"       = stations,
                         "dataItems"     = dataitems,
                         "startDate"     = startdate,
                         "endDate"       = enddate,
                         "unitOfMeasure" = units))

  # inform whether success or failure
  cat(paste("CIMIS API reports the following status: ", http_status(r1)$message), "\n")

  # Parse the JSON objects into Data Frames ---------------------------------

  # First we use httr's <content> function to parse the JSON objects into a nested R list.
  # Then we dive down into the list and retrieve the Records node, which
  # contains the data as a list of dates, each containing a list of nine fields.
  # Finally, we use <sapply> to iterate through the dates and retrieve the data
  # in five of the nine fields, storing it in a data frame <cimisdata>. At the
  # moment, this only works for daily data. Future update will work with hourly
  # data and allow user to specify only specific fields to extract.

  cimisdata <- content(r1, "parsed")[[1]][[1]][[1]]$Records

  # Replace any NULL values with NAs. Otherwise the unlisting won't work.
  cimisdata <- simple_rapply(cimisdata, function(x) if(is.null(x)) NA else x)

  # Unpack the list into a data frame
  cimisdata <- data.frame(date = as.Date(sapply(cimisdata, function(x) x$Date)),
                          station = as.numeric(sapply(cimisdata, function(x) x$Station)),
                          meandailytemp = as.numeric(sapply(cimisdata, function(x) x$DayAirTmpAvg$Value)),
                          dailyETo = as.numeric(sapply(cimisdata, function(x) x$DayEto$Value)),
                          dailyprecip = as.numeric(sapply(cimisdata, function(x) x$DayPrecip$Value)))
  cat("Downloaded", NROW(cimisdata), "daily observations")
  return(cimisdata)
}
### END


### For debugging only
#r1 <- GET("http://et.water.ca.gov/api/data",
#          query = list("appKey"        = '5e0d7efd-76fb-4c82-9437-3331ba5b07b0',
#                       "targets"       = 135,
#                       "dataItems"     = 'day-air-tmp-avg, day-precip, day-eto',
#                       "startDate"     = '2019-01-01',
#                       "endDate"       = today()-2,
#                       "unitOfMeasure" = 'E'))
