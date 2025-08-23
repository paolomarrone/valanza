#!/bin/awk -f

BEGIN {
	if (col == "") {
		col = 2
	}
}

{
	sum += $col
	count++
}

END {
	if (count > 0) {
		print sum / count
	} else {
		print 0
	}
}