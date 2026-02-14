#!/usr/bin/env Rscript

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
merged_data <- merge(all_data, data, by = "Date", all.x = TRUE)

# Interpolate numeric columns using linear interpolation
numeric_cols <- names(data)[2:ncol(data)]
for (col in numeric_cols) {
	merged_data[[col]] <- round(approx(seq_along(merged_data[[col]]), merged_data[[col]], 
	                                   xout = seq_along(merged_data[[col]]), 
	                                   method = "linear")$y, digits = 2)
}

# Replace remaining NAs with previous values (forward fill)
for (col in numeric_cols) {
	na_idx <- which(is.na(merged_data[[col]]))
	if (length(na_idx) > 0) {
		for (i in na_idx) {
			if (i > 1) {
				merged_data[[col]][i] <- merged_data[[col]][i - 1]
			}
		}
	}
}

# Print output in the same format (space-separated, no quotes)
write.table(merged_data, file = "", sep = " ", row.names = FALSE, col.names = FALSE, quote = FALSE)