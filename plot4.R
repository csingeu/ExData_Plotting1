# This script will:
# 1. Load the household power consumption data for 2007-02-01 and 2007-02-02
# 2. Construct 4 plots in a 2x2 grid
# 3. Save as a 480x480 PNG image

# 1. Load data
# Checks if clean.txt is available for processing
if (!file.exists('clean.txt')) {
        print("clean.txt does not exist.");
        
        # Checks if household_power_consumption.txt exists
        if (!file.exists('household_power_consumption.txt')) {
                print("household_power_consumption.txt does not exist.")
                
                # Checks if exdata-data-household_power_consumption.zip exists
                if (!file.exists('exdata-data-household_power_consumption.zip')) {
                        # Download and unzip raw file
                        print("exdata-data-household_power_consumption.zip does not exist.")
                        print("Preparing to download zip file......")
                        download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', destfile='exdata-data-household_power_consumption.zip')
                        print("File downloaded.")        
                } else {
                        print("exdata-data-household_power_consumption.zip exists.")                       
                }
                print("Unzipping file......")
                unzip('exdata-data-household_power_consumption.zip')
                print('File unzipped.') 
                
        } else {
                print("household_power_consumption.txt exists.")
        }
        
        print("Processing household_power_consumption.txt......")
        # Read data into table
        power <- read.table('household_power_consumption.txt', header=TRUE,
                            sep=';', na.strings='?',
                            colClasses=c(rep('character', 2), 
                                         rep('numeric', 7)))
        
        # Format date/time fields
        power$Time <- strptime(paste(power$Date, power$Time), "%d/%m/%Y %H:%M:%S")
        power$Date <- as.Date(power$Date, "%d/%m/%Y")
        
        # Set valid date range
        valid_dates <- as.Date(c("2007-02-01", "2007-02-02"), "%Y-%m-%d")
        
        # Subset data
        power <- subset(power, Date %in% valid_dates)
        
        print("Data loaded.")
        
        # Output subset data to clean.txt
        write.table(power, "clean.txt", sep=";")
        
        print("Saved to clean.txt")
        
} else {
        # if clean.txt exists, load data into table for processing
        print("clean.txt exists.")
        
        # Read data into table
        power <- read.table('clean.txt', header=TRUE,
                            sep=';', na.strings='?',
                            colClasses=c('character', 'Date', 'character', 
                                         rep('numeric', 7)))
        
        # Format date/time
        power$Time <- strptime(power$Time, "%Y-%m-%d %H:%M:%S")
        print("Data loaded.")
}

# 2. Construct plot

# Change plot display to 2x2
o_mfrow <- par("mfrow")
o_cex <- par("cex")
o_mar <- par("mar")
par(mfrow=c(2,2))
par(cex=.75)
par(mar=c(4,4,1,1))

print("Plot graph 1...")
plot(power$Time, power$Global_active_power,
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)")

print("Plot graph 2...")
plot(power$Time, power$Voltage,
     type="l",
     xlab="datetime",
     ylab="Voltage")

print("Plot graph 3...")
plot(power$Time, power$Sub_metering_1, type="l", col="black",
     xlab="", ylab="Energy sub metering")
lines(power$Time, power$Sub_metering_2, col="red")
lines(power$Time, power$Sub_metering_3, col="blue")
legend("topright",
       col=c("black", "red", "blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       c("Sub_metering_1      ", "Sub_metering_2      ", "Sub_metering_3      "),
       bty='n',
       lty=1,
       pt.cex = 1,
       cex = 0.75,
       y.intersp = .5)

print("Plot graph 4...")
plot(power$Time, power$Global_reactive_power, 
     type="l",
     xlab="datetime", 
     ylab="Global_reactive_power")


# 3. Save plot as PNG
dev.copy(png, width=480, height=480, file="plot4.png")
dev.off()
print("Saved to plot4.png")

# Restore to original settings
par(mfrow = o_mfrow)
par(cex = o_cex)
par(mar = o_mar)

