#!/bin/awk -f

# row: date num

BEGIN {
	if (col == "") {
		col = 1
	}
	getline
	y = $2
	print $2
}

{
	y = y * 0.9 + $2 * 0.1
	print y
}
