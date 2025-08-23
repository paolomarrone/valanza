#!/bin/bash

# derived from https://stackoverflow.com/questions/55033160/how-to-interpolate-an-array-in-awk

# linear interpolation
# row: date num num num ...

awk '
BEGIN {
	# Initialize "previous" line
	getline;
	for (i=0; i<=NF; i++) p[i] = $i;
}
{
	# Print previous line
	print p[0];

	# Convert dates to numerical format for comparison (YYYY-MM-DD to days since epoch)
	split(p[1], p_date, "-");
	split($1, c_date, "-");
	p_days = mktime(p_date[1] " " p_date[2] " " p_date[3] " 0 0 0") / 86400;
	c_days = mktime(c_date[1] " " c_date[2] " " c_date[3] " 0 0 0") / 86400;

	# Check if date has skipped (more than 1 day difference)
	if ((d = c_days - p_days) > 1) {
		# Insert (d-1) new rows for missing dates
		for (i=1; i<d; i++) {
			# Generate interpolated date
			interp_days = p_days + i;
			interp_date = strftime("%Y-%m-%d", interp_days * 86400);

			# Print interpolated date
			printf "%s ", interp_date;

			# Interpolate values for other columns (if numeric)
			for (c=2; c<=NF; c++) {
				printf "%s%s",
					p[c] + (i/d)*($c-p[c]),  # Linear interpolation for numeric columns
					c==NF ? ORS : OFS;       # Avoid trailing spaces
			}
		}
	}

	# Update previous line
	for (i=0; i<=NF; i++) p[i] = $i;
}
END {
	# Print the final line
	print p[0];
}
'