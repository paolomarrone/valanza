#!/usr/bin/env Rscript

library(dplyr)
library(tidyr)
library(zoo)

# Read input from stdin or a file
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
	data <- read.csv(args[1], sep = " ", header = FALSE, stringsAsFactors = FALSE)
} else {
	data <- read.csv(file("stdin"), sep = " ", header = FALSE, stringsAsFactors = FALSE)
}

colnames(data) <- c("Date", paste0("V", seq(2, ncol(data))))

# Convert first column to Date
data$Date <- as.Date(data$Date)

# Create a sequence of all dates from min to max
all_dates <- seq(min(data$Date), max(data$Date), by = "day")

# Create a data frame with all dates
all_data <- data.frame(Date = all_dates)

# Merge with original data to fill missing dates
merged_data <- all_data %>% 
	left_join(data, by = "Date")

# Interpolate numeric columns using linear interpolation
numeric_cols <- names(data)[2:ncol(data)]
for (col in numeric_cols) {
	merged_data[[col]] <- round(na.approx(merged_data[[col]], na.rm = FALSE), digits = 1)
}

# Replace NA with previous values for non-numeric columns (if any)
# (Assuming all columns except Date are numeric in this case)
merged_data <- merged_data %>% fill(all_of(numeric_cols), .direction = "down")

# Print output in the same format (space-separated, no quotes)
write.table(merged_data, file = "", sep = " ", row.names = FALSE, col.names = FALSE, quote = FALSE)