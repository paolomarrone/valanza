#!/bin/bash

DATA_FILE=$1
PLOT_FILE="plot.gp"

# Number of days for moving average
DAYS=7

if [ ! -f "$DATA_FILE" ]; then
	echo "Error: $DATA_FILE not found"
	exit 1
fi

# Calculate mean of last N days
mean=$(tail -n "$DAYS" "$DATA_FILE" | awk '{sum += $2; count++} END {if (count > 0) print sum/count; else print 0}')

# Print all entries and the mean
echo "Last $DAYS entries:"
tail -n "$DAYS" "$DATA_FILE"
echo "Mean weight (last $DAYS days): $mean"


cat "$DATA_FILE" | ./interpolate_lin.R | gnuplot -persist "$PLOT_FILE"
