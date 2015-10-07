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

png(file="plot2.png")

plot(power2$datetime, power2$Global_active_power, typ="l", ylab="Global Active Power (kilowatts)", xlab="")

dev.off() ## close the PNG device