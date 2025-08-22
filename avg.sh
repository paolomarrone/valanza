#!/bin/bash

# avg.sh: Calculate mean of weight values from stdin
awk '{sum += $2; count++} END {if (count > 0) print sum/count; else print 0}'