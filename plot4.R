library(lubridate)
library(dplyr)

## Read the data file (NOTE: read in as character to avoid values being classified as factors)
power <- read.table(file, header=TRUE, sep=";", colClasses = "character")

## Tidy up the data by using only the data from 2/1/2007 to 2/2/2007 
## and converting Date and Time fields to actual Date/Time class

power <- tbl_df(power)

power2 <- power %>% 
        filter(Date == '1/2/2007' | Date == '2/2/2007') %>%     ## read only 2/1 and 2/2 from yr 2007
        mutate(datetime = dmy_hms(paste(Date, Time))) %>%       ## convert Date and Time to datetime
        select(-(Date:Time))                                    ## remove Date and Time columns

## convert the characters back to numeric.  This will also automatically convert ? to NA
power2[,1:7] <- lapply(power2[,1:7], as.numeric)

## Open png device
png(file="plot4.png")

## print 4 charts in one page 2 rows and 2 columns
par(mfrow = c(2,2))

## plot #1
plot(power2$datetime, power2$Global_active_power, typ="l", ylab="Global Active Power", xlab="")

## plot #2
plot(power2$datetime, power2$Voltage, typ="l", ylab="Voltage", xlab="datetime")

## plot #3
with(power2, plot(datetime, Sub_metering_1, main = "", typ = "l"
                  , ylab = "Energy sub metering", xlab=""))
with(power2, lines(datetime, Sub_metering_2, col = "red"))
with(power2, lines(datetime, Sub_metering_3, col = "blue"))
legend("topright", col = c("black", "blue", "red"), lty = 1, bty = "n"
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## plot #4
plot(power2$datetime, power2$Global_reactive_power, typ="l", ylab="Global_reactive_power", xlab="datetime")

dev.off() ## close the PNG device