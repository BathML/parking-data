# Script for parsing HTML table of Wunderground weather data for Bath :)

library(rvest)
library(dplyr)
library(lubridate)

# Use the Wunderground website to manually search for a date range, then copy
# the URL and paste it below. Use the URL below to get to the right search page!

# Get the webpage
wg <- read_html("https://www.wunderground.com/history/airport/EGTG/2016/12/28/CustomHistory.html?dayend=25&monthend=7&yearend=2017&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=")

# Find the second table on the webpage (the massive weather table)
wgtab <- html_table(wg, header = FALSE)[[2]]

# Set column names
names(wgtab) <- c("GMT", "Max TemperatureC", "Mean TemperatureC",
                  "Min TemperatureC", "Max DewPointC", "Mean DewPointC",
                  "Min DewpointC", "Max Humidity", "Mean Humidity",
                  "Min Humidity", "Max Sea Level PressurehPa",
                  "Mean Sea Level PressurehPa", "Min Sea Level PressurehPa",
                  "Max VisibilityKm", "Mean VisibilityKm", "Min VisibilitykM",
                  "Max Wind SpeedKm/h", "Mean Wind SpeedKm/h",
                  "Max Gust SpeedKm/h", "Precipitationmm",
                  "Events")

# Add a new Date column, in numeric format for conversion later
wgtab$Date <- vector(length = nrow(wgtab), mode = "numeric")

# For each row in the massive table:
for (i in 1:nrow(wgtab)) {
    
    # All entries are currently character type. Try to convert the first column
    # of the row to a number: if we get NA, then it must have been a month name,
    # so move on without doing anything
    if (is.na(as.numeric(wgtab$GMT[i]))) next
    
    # Otherwise, see if the number is >31 - if it is, then it's a year, rather
    # than a day
    if (as.numeric(wgtab$GMT[i]) > 31) {
        
        # Start counting in this little month-long subsection of the table
        j = 0
        
        # Convert the current value in the first column to a number (we did this
        # already to check if we *could* do it, but we didn't store it before)
        current_row <- as.numeric(wgtab$GMT[i+j])
        
        # We know that this is a year number (that's why we went into this if
        # statement!), so store it as the year (yr) of this subsection
        yr <- current_row
        
        # Move on to the next row
        j = j + 1
        current_row <- as.numeric(wgtab$GMT[i+j])
        
        # We just converted the next row's first entry to numeric; if we got NA,
        # it must have been a month name, rather than a day number
        if (is.na(current_row)) {
            
            # So store the month number (we look up the 3-letter abbreviation,
            # and return the corresponding month number)
            mo <- which(month.abb == wgtab$GMT[i+j])
            
            # Move on to the next row
            j <- j + 1
            current_row <- as.numeric(wgtab$GMT[i+j])
        }
        
        # Now we keep going down the rows until we hit another year or month row
        # (in which case, when we convert to numeric, we'll either get a NA or
        # a number bigger than 2000)
        while (!is.na(current_row) && current_row < 2000) {

            # So we know the current first entry of this row must now be a day
            # number - so store it!
            dy <- current_row
            
            # Set up a date placeholder
            dt <- as_date("2000-01-01")
            
            # Change the year, month and day entries to the stored values
            year(dt) <- yr
            month(dt) <- mo
            day(dt) <- dy
            
            # Print it so we can check on the loop's progress
            print(dt)
            
            # Write this date to the Date column
            wgtab$Date[i+j] <- dt
            
            # Move on to the next row!
            j <- j+1
            current_row <- as.numeric(wgtab$GMT[i+j])
        }
    }
}

# We didn't write dates to rows where the first entry was a year number or month
# abbreviation (these rows didn't contain data), so get rid of the rows where
# the Date column still has a value of 0 (which is what we initiated it with)
wgtab <- filter(wgtab, Date != 0) %>%
    # Convert the Date column from numeric to date format
    mutate(Date = as_date(Date)) %>%
    # Get rid of the stupid column we've just turned into the nice Date column
    select(-GMT)
    
# Re-order the columns to move Date to the left (it's currently the last column)
wgtab <- wgtab[, c(21, 1:20)]