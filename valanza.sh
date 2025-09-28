#!/bin/bash

DATA_FILE=$1
PLOT_FILE="plot.gp"

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

paste -d " " $RAM_DIR/raw.txt $RAM_DIR/mov.txt $RAM_DIR/lp1.txt > $RAM_DIR/all.txt

gnuplot -e "datafile='$RAM_DIR/all.txt'" -persist $PLOT_FILE
