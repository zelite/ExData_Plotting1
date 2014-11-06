library(dplyr)

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
png(filename = "plot1.png", width = 480, height = 480)
hist(data.to.plot$Global_active_power, xlab = "Global Active Power (kilowatts)",
     col="red", main = "Global Active Power")
dev.off()
             
