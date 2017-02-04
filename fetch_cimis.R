### CIMIS Data Import
### Lauren Steely, MWD
### January 2017

# Defines function fetch_cimis(), which downloads CIMIS data using the web API for a specified period, for the specified stations, and returns the data as a tidy data frame. Requires an API key (a character string) which can be obtained from the CIMIS website after registering.

# stations  : one or more station IDs (can be a list object) as either numeric or character
# startdate : start of time range; a string formatted as "YYYY-MM-DD"
# enddate   : end of time range; a string formatted as "YYYY-MM-DD"
# units     : "E" for imperial units or "M" for metric units
# key       : an API key obtained from the CIMIS website; character string

# Example usage: cimisdata <- fetch_cimis(151, "2015-01-1, "2016-12-31", mykey)

require(httr)   # access web APIs

# Download CIMIS data. We use httr's <GET> function and pass it the URL of the API, a private key (register on CIMIS website to obtain), the station ID, the fields we're interested in, and a date range. The API has a data limit for a single request (if too big it will return http status 400) so we must download in three date-range batches. The responses are returned as JSON objects, nested key-value pairs, and stored as r1, r2 and r3. If successful, http_status(r) will return code "200".

fetch_cimis <- function(stations, startdate, enddate, units="E", key) {

  stations <- as.character(stations)
 # dataitems <- ifelse(type == "daily", "day-air-tmp-avg, day-precip, day-eto", "hly-air-tmp-avg, hly-precip, hly-eto")
  cat("Downloading CIMIS data...", "\n")
  r1 <- GET("http://et.water.ca.gov/api/data",
            query = list("appKey"        = key,
                         "targets"       = stations,
                         "startDate"     = startdate,
                         "endDate"       = enddate,
                         "unitOfMeasure" = units))
  cat(paste("CIMIS API reports the following status: ", http_status(r1)$message), "\n") # inform whether success or failure

  # Parse the JSON objects into Data Frames ---------------------------------

  # First we use httr's <content> function to parse the JSON objects into lists.
  # Then we dive down into the lists and retrieve the Records node, which
  # contains the data as a list of dates, each containing a list of nine fields.
  # Finally, we use <sapply> to iterate through the dates and retrieve the data
  # in five of the nine fields, storing it in a data frame <cimisdata>.

  cimisdata <- content(r1, "parsed")[[1]][[1]][[1]]$Records # parse JSON data & extract records from the resulting list
  cimisdata <- data.frame(date = as.Date(sapply(cimisdata, function(x) x[[1]])),
                           station = sapply(cimisdata, function(x) x[[2]]),
                           meandailytemp = as.numeric(sapply(cimisdata, function(x) x[[7]]$Value)),
                           dailyETo = as.numeric(sapply(cimisdata, function(x) x[[8]]$Value)),
                           dailyprecip = as.numeric(sapply(cimisdata, function(x) x[[9]]$Value)))

  rm(r1) # clean up
  cat("Downloaded", NROW(cimisdata), "observations")
  return(cimisdata)
}
### END
