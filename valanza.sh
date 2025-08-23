#!/bin/bash

DATA_FILE=$1
PLOT_FILE="plot.gp"

# Number of days for moving average
DAYS=7

if [ ! -f "$DATA_FILE" ]; then
	echo "Error: $DATA_FILE not found"
	exit 1
fi

gnuplot -persist << EOF
	set xdata time
	set timefmt "%Y-%m-%d"
	set format x "%Y-%m-%d"
	set xlabel "Date"
	set ylabel "Weight (kg)"
	set grid
	plot '<cat "$DATA_FILE" | ./interpolate_lin.R'                 using 1:2 with lines title "Raw Data", \
		 '<cat "$DATA_FILE" | ./interpolate_lin.R | ./mov_avg.awk' using 1:2 with lines title "7-Day Moving Average", \
		 '<cat "$DATA_FILE" | ./interpolate_lin.R | ./lp1.awk'     using 1:2 with lines title "Low-Pass Filter"
EOF