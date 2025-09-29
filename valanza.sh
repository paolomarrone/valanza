#!/bin/bash

DATA_FILE=$1
PLOT_FILE="plot.gp"

if [ ! -f "$DATA_FILE" ]; then
	echo "Error: $DATA_FILE not found"
	exit 1
fi

RAM_DIR="/dev/shm/$(basename "$0")_$$"  # Use script name + PID for uniqueness
mkdir -p "$RAM_DIR"

mkfifo $RAM_DIR/raw $RAM_DIR/avg $RAM_DIR/lp1

cat "$DATA_FILE" | ./interpolate_lin.R | tee \
	$RAM_DIR/raw \
	>(./mov_avg.awk > $RAM_DIR/avg) \
	>(./lp1.awk > $RAM_DIR/lp1) \
	> /dev/null &

paste -d " " \
	<(cat $RAM_DIR/raw) \
	<(cat $RAM_DIR/avg) \
	<(cat $RAM_DIR/lp1) \
	> $RAM_DIR/all.txt

gnuplot -e "datafile='$RAM_DIR/all.txt'" -persist $PLOT_FILE
