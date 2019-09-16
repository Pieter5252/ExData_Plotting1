## This script downloads the required data and creats the plot "plot1.png"

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
hpcdata$Time <- with(hpcdata, hms(Time))

## Subset only the data needed

hpcdata <- hpcdata %>% filter(Date == "2007-02-01" | Date == "2007-02-02")

## Setting up the plot

png(filename = "plot1.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white", res = NA, family = "", restoreConsole = TRUE)


## Plot

hist(hpcdata$Global_Active_Power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

## Close

dev.off()