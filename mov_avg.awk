#!/bin/awk -f

BEGIN {
	if (col == "") {
		col = 1
	}
	if (win == "") {
		win = 7
	}

	head = 1
	tail = 1
	current_sum = 0
	current_win = 1
}

{
	val = $col
	window_data[tail] = val
	current_sum += val
	tail++

	if ((tail - head) > current_win) {
		current_sum -= window_data[head]
		head++
	}

	if ((tail - head) == current_win) {
		print current_sum / current_win
	}
	if (current_win < win) {
		current_win++;
	}
}

END {

}
