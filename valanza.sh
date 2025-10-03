#!/bin/bash

DATA_FILE=$1
PLOT_FILE="plot.gp"

if [ ! -f "$DATA_FILE" ]; then
	echo "Error: $DATA_FILE not found"
	exit 1
fi

RAM_DIR="/dev/shm/$(basename "$0")_$$"
mkdir -p "$RAM_DIR"

mkfifo $RAM_DIR/dates $RAM_DIR/int $RAM_DIR/avg $RAM_DIR/lp1

cat $DATA_FILE | ./interpolate_lin.R | tee \
	>(cut -d' ' -f1                    > $RAM_DIR/dates) \
	>(cut -d' ' -f2                    > $RAM_DIR/int) \
	>(./mov_avg.awk -v col=2 -v win=11 > $RAM_DIR/avg) \
	>(./lp1.awk     -v col=2           > $RAM_DIR/lp1) \
	> /dev/null &

paste -d " " \
	<(cat $RAM_DIR/dates) \
	<(cat $RAM_DIR/int) \
	<(cat $RAM_DIR/avg) \
	<(cat $RAM_DIR/lp1) \
	> $RAM_DIR/all.txt

gnuplot -e "datafile='$RAM_DIR/all.txt'" -persist $PLOT_FILE
