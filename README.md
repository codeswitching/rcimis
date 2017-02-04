# rcimis
An R package to download and process CIMIS (California Irrigation Management System) data
by Lauren Steely

CIMIS is a network of agricultural weather stations throughout California that record hourly data on temperature, precipitation, windspeed, humidity, solar radiation, and reference evapotranspiration. This package provides the fetch_cimis() function to fetch data from the CIMIS API and store it in a tidy data frame, without having to know how to use the API or extract data from JSON objects, which can be awkward in R. Users must have an API key, which can be obtained from the CIMIS website after registering for an account (see http://et.water.ca.gov/Home/Register/)
