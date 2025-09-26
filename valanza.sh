#!/bin/bash

DATA_FILE=$1
PLOT_FILE="plot.gp"

# Number of days for moving average
DAYS=7

if [ ! -f "$DATA_FILE" ]; then
	echo "Error: $DATA_FILE not found"
	exit 1
fi

RAM_DIR="/dev/shm/$(basename "$0")_$$"  # Use script name + PID for uniqueness
mkdir -p "$RAM_DIR"

cat "$DATA_FILE" | ./interpolate_lin.R | tee \
	$RAM_DIR/raw.txt \
	>(./mov_avg.awk > $RAM_DIR/mov.txt) \
	>(./lp1.awk > $RAM_DIR/lp1.txt) \
	> /dev/null


gnuplot -persist << EOF
	set xdata time
	set timefmt "%Y-%m-%d"
	set format x "%Y-%m-%d"
	set xlabel "Date"
	set ylabel "Weight (kg)"
	set grid
	plot '<cat "$RAM_DIR/raw.txt" ' using 1:2 with lines title "Raw Data", \
		 '<cat "$RAM_DIR/mov.txt" ' using 1:2 with lines title "7-Day Moving Average", \
		 '<cat "$RAM_DIR/lp1.txt" ' using 1:2 with lines title "Low-Pass Filter"
EOF
