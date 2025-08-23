#!/bin/bash

col=${1:-1}

awk -v column="$col" '\
{
	sum += $column
	count++
}
END {
	if (count > 0) {
		print sum / count
	} else {
		print 0
	}
}'
