# rcimis
An R package to download and process CIMIS (California Irrigation Management System) data

Lauren Steely

CIMIS is a network of agricultural weather stations throughout California that record hourly data on temperature, precipitation, windspeed, humidity, solar radiation, and reference evapotranspiration. This package provides the fetch_cimis() function to fetch data from the CIMIS API and extract the resulting JSON object into a tidy data frame, without having to know how to use the API, which can be awkward in R.

Users must have an API key, which can be obtained from the CIMIS website after registering for an account (see http://et.water.ca.gov/Home/Register/). Note that there was previously a \<cimis\> package for R, but it was removed from CRAN for unknown reasons.

Also included is code to generate standardized graphs of ETo (or Temperature) and Precipitation as plot.ly charts:
<div>    <img src="https://plot.ly/~modalmixture/16.png?share_key=eNjBrBjBppyACNJLDnGsmH" alt="CIMIS data" style="max-width: 100%;" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" />    <script data-plotly="modalmixture:16" sharekey-plotly="eNjBrBjBppyACNJLDnGsmH" src="https://plot.ly/embed.js" async></script></div>
