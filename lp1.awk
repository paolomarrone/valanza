#!/usr/bin/awk -f

BEGIN {
	col = col ? col : 1

	getline
	y = $col
	print $col
}

{
	y = y * 0.9 + $col * 0.1
	print y
}
