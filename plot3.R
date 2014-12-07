# This script will:
# 1. Load the household power consumption data for 2007-02-01 and 2007-02-02
# 2. Construct a plot (line-based timeseries) of Energy Sub metering 1,2,3 vs Time
# 3. Save plot as a 480x480 PNG image

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
o_mfrow <- par("mfrow")
par(mfrow = c(1,1))

print("Plot graph...")
plot(power$Time, power$Sub_metering_1, type="l", col="black",
     xlab="", ylab="Energy sub metering")
lines(power$Time, power$Sub_metering_2, col="red")
lines(power$Time, power$Sub_metering_3, col="blue")
legend("topright",
       col=c("black", "red", "blue"),
       c("Sub_metering_1      ", "Sub_metering_2      ", "Sub_metering_3      "),
       lty=1,
       pt.cex = 1,
       cex = 0.75,
       y.intersp = .5)

# 3. Save plot as PNG
dev.copy(png, width=480, height=480, file="plot3.png")
dev.off()
print("Saved to plot3.png")

# 4. Restore settings
par(mfrow = o_mfrow)


