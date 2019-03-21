#ingest data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
df <- read.table(unz(temp, "household_power_consumption.txt"),header=T,sep=";",na.strings="?",stringsAsFactors=F)
unlink(temp)

library(lubridate)
df<-na.exclude(df)
#correct formatting
df$Date = as.Date(df$Date,format="%d/%m/%Y")
#select Feb 1&2
df3<- subset(df, Date%in%c(as.Date("2007-2-1"),as.Date("2007-2-2")))
#formt as time
df3$Time <- format(strptime(df3$Time, format="%H:%M:%S"),"%H:%M:%S")
#combine to date-time format
df3$DateTime<-paste(df3$Date,df3$Time)
#convert formatting
df3$DateTime<-ymd_hms(df3$DateTime)
#plot
png(file="plot1.png")
hist(df3$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)",col="red")
dev.off()
