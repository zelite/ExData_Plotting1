library(dplyr)
library(stringr)

Sys.setlocale(category = "LC_ALL", "C") #to have the weekday lables in english
# READING FILE
# there's a row every minute, so the rows to import were calculated to only have the rows needed for the assignment

startFile <- as.POSIXct("2006-12-16 17:24:00")
startTime <- as.POSIXct(" 2007-02-01 00:00:00")
endTime <- as.POSIXct("2007-02-03 00:00:00")

startRow <- as.numeric(difftime(startTime, startFile, units="mins"))+1 # "+1" because headers also count as row
nRows <- as.numeric(difftime(endTime, startTime, units="mins"))

#create a connection to the zip file
con <- unz(description = "exdata_data_household_power_consumption.zip", 
           filename = "household_power_consumption.txt")

#read the headers
headers <- unlist(str_split(readLines(con, n = 1), ";"))
#read the data from connection
data.to.plot <- read.table(con, header = FALSE, sep=";",
                           colClasses = c("character", "character", rep("numeric", 7)), 
                           na.strings = "?", skip=startRow, nrow=nRows)
#in read.table colClasses are defined to speed things up. 

#put the headers on the data
names(data.to.plot) <- headers


data.to.plot <- as.tbl(data.to.plot)
#dplyr does not support POSIXlt, so need to explicity define POSIXct
data.to.plot <- mutate(data.to.plot, 
                       datetime = as.POSIXct(strptime(paste(Date, Time), format = "%d/%m/%Y %T")))


#Now the plot code
png(filename = "plot3.png", width = 480, height = 480)

plot(x=data.to.plot$datetime, y = data.to.plot$Sub_metering_1,
     type="l", xlab="", ylab="Energy sub metering")
lines(x=data.to.plot$datetime, y = data.to.plot$Sub_metering_2,
      col = "red")
lines(x=data.to.plot$datetime, y = data.to.plot$Sub_metering_3,
      col = "blue")
legend(x="topright", legend = paste0("Sub_metering_", 1:3), lty = rep(1,3),
       col = c("black", "red", "blue"))

dev.off()
             
