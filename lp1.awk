#!/bin/awk -f

# row: date num

BEGIN {
	col = 2
	getline
	y = $2
	print $1 " " $2
}

{
	y = y * 0.9 + $2 * 0.1
	print $1 " " y
}
