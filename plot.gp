set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
set xlabel "Date"
set ylabel "Weight (kg)"
set grid
plot datafile using 1:2 with lines title "Raw Data", \
     datafile using 1:3 with lines title "7-Day Moving Average", \
     datafile using 1:4 with lines title "Low-Pass Filter"