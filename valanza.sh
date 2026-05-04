#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DATA_FILE=$1
DAYS=${2:-}

if [ ! -f "$DATA_FILE" ]; then
	echo "Error: $DATA_FILE not found"
	exit 1
fi

if [ -n "$DAYS" ] && ! [[ "$DAYS" =~ ^[1-9][0-9]*$ ]]; then
	echo "Error: DAYS must be a positive integer"
	exit 1
fi

if [ -d "/dev/shm" ]; then
	RAM_DIR="/dev/shm/$(basename "$0")_$$"
else
	RAM_DIR="/tmp/$(basename "$0")_$$"
fi

mkdir -p "$RAM_DIR"
trap 'rm -rf -- "$RAM_DIR"' EXIT

mkfifo "$RAM_DIR/dates" "$RAM_DIR/int" "$RAM_DIR/avg" "$RAM_DIR/lp1"

cat "$DATA_FILE" \
	| "$SCRIPT_DIR/interpolate_lin.R" \
	| { [ -n "$DAYS" ] && tail -n "$DAYS" || cat; } \
	| tee \
		>(cut -d' ' -f1                                 > "$RAM_DIR/dates") \
		>(cut -d' ' -f2                                 > "$RAM_DIR/int")   \
		>("$SCRIPT_DIR/mov_avg.awk" -v col=2 -v win=11  > "$RAM_DIR/avg")   \
		>("$SCRIPT_DIR/lp1.awk"     -v col=2            > "$RAM_DIR/lp1")   \
		> /dev/null &

paste -d " " \
	<(cat "$RAM_DIR/dates") \
	<(cat "$RAM_DIR/int")   \
	<(cat "$RAM_DIR/avg")   \
	<(cat "$RAM_DIR/lp1")   \
	> "$RAM_DIR/all.txt"

gnuplot -e "datafile='$RAM_DIR/all.txt'" -persist "$SCRIPT_DIR/plot.gp"
