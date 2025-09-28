#!/bin/awk -f

# row: date num

BEGIN {
	col = 2
	getline
	y = $2
	print $2
}

{
	y = y * 0.9 + $2 * 0.1
	print y
}
