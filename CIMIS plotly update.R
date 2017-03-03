# Plot Precip and ET

  cat("Plotting data...\n")
  
  weather2016 <- cimisdata %>% filter(date > as.Date("2015-12-31"), dailyETo > 0) # adjust date range as needed
  
  l <- plot_ly(weather2016, x=~date, y=~dailyETo, type="scatter", mode="lines", yaxis="y1", name="ETo",
               line=list(color="orange")) %>%
    add_trace(weather2016, x=~date, y=~dailyprecip, type="bar", yaxis = "y2", name="Precip",
              marker=list(color="rgb(8, 148, 207")) %>%
    layout(xaxis = list(title = '', range = c(as.numeric(as.Date("2016-01-01"))*86400000,
                                              as.numeric(as.Date("2017-02-01"))*86400000)),
           yaxis = list(side="left", title = 'Daily ETo (inches)', zeroline=FALSE),
           yaxis2 = list(overlaying="y", side="right", showgrid=FALSE, title="Daily Precip (inches)"))
  l
  cat("Publishing to plot.ly dashboard...\n")
  plotly_POST(l, "CIMIS data")


