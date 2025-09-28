#!/bin/awk -f

# assumes row: date num

BEGIN {
	col = 2
	if (win == "") {
		win = 7
	}

	head = 1
	tail = 1
	current_sum = 0
	current_win = 1
	# 'window_data' is an associative array that will store the values
	# within the current sliding window.
}

{
	val = $col

	# Add the current value to our window_data array and update the sum.
	# 'tail' acts as the index for the new element.
	window_data[tail] = val
	current_sum += val
	tail++ # Move the tail pointer forward for the next element.

	# Check if the window size has exceeded the 'win' limit.
	# If it has, we need to remove the oldest element from the front of the window.
	if ((tail - head) > current_win) {
		# Subtract the value of the oldest element from current_sum.
		current_sum -= window_data[head]
		# Advance the head pointer, effectively removing the oldest element.
		head++
	}

	# Once the window is full (i.e., it contains 'win' elements),
	# calculate and print the moving average.
	if ((tail - head) == current_win) {
		# The moving average is the current_sum divided by the window size.
		print current_sum / current_win
	}
	if (current_win < win) {
		current_win++;
	}
}

END {

}
