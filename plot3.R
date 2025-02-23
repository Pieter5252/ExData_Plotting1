## This script downloads the required data and creats the plot "plot3.png"

## Load dependancies

library(dplyr)
library(lubridate)

## Download the data

if (!file.exists("household_power_consumption.txt")) {
  link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  dest <- "power_consumtion.zip"
  download.file(link, dest, method = "curl")
  unzip(dest)
}

## Read the data into R

cname <- c("Date", 
           "Time", 
           "Global_Active_Power", 
           "Global_Reactive_Power", 
           "Voltage", 
           "Global_Intensity", 
           "Sub_Metering_1", 
           "Sub_Metering_2", 
           "Sub_Metering_3")
hpcdata <- tbl_df(read.table("household_power_consumption.txt", col.names = cname, 
                             sep = ";", skip = 1, na.strings = "?"))

hpcdata$Date <- with(hpcdata, dmy(Date))
hpcdata <- hpcdata %>% filter(Date == "2007-02-01" | Date == "2007-02-02")  ## Subset only the data needed
hpcdata$Time <- with(hpcdata, as_datetime(paste(Date, Time)))               ## Parse "Date" and "Time"

## Setting up the plot

png(filename = "plot3.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white", res = NA, family = "", restoreConsole = TRUE)


## Plot

with(hpcdata,
     plot(Time,
          Sub_Metering_1,
          type = "l",
          xlab = "",
          ylab = "Energy sub metering"
          ))
legend("topright", lty = 1, col=c("black", "red", "blue"), legend=c("Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3"))

with(hpcdata,
     lines(Time,
          Sub_Metering_2,
          type = "l", col = "red"
     ))
with(hpcdata,
     lines(Time,
          Sub_Metering_3,
          type = "l", col = "blue"
     ))


## Close

dev.off()