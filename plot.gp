set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
set xlabel "Date"
set ylabel "Weight (kg)"
plot '<cat' using 1:2 with linespoints pointtype 7 title "Weight"