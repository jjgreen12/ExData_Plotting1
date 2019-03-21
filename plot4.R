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
png(file="plot4.png")
par(mfrow=c(2,2),mar=c(4,4,2,1))
plot(df3$Global_active_power~df3$DateTime,type="line",ylab="Global Active Power (kilowatts)",xlab="")
plot(df3$Voltage~df3$DateTime,type="line",ylab="Voltage (volt)",xlab="")
plot(df3$Sub_metering_1~df3$DateTime,type="line",ylab="Global Active Power (kilowatts)",xlab="")
lines(df3$Sub_metering_2~df3$DateTime,col='Red')
lines(df3$Sub_metering_3~df3$DateTime,col='Blue')
legend("topright",col=c("black","red","blue"),lwd=c(1,1,1),
       c("Sub-Metering 1","Sub-Metering 2","Sub-Metering 3"))
plot(df3$Global_reactive_power~df3$DateTime,type="line",ylab="Global Reactive Power (kilowatts)",xlab="")
dev.off()