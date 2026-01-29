# Valanza

A weight tracking and analysis tool built the UNIX way: small, composable programs working together through pipes.

## Why

I didn't like the idea of having both data and logic in one spreadsheet. I want to write programs in the right language for the right task, not cram everything into huge formulas in a single cellspace.

This might evolve into a UNIX-style calc alternative howto.

## Requirements

- bash
- R
- awk
- gnuplot
- rc (optional, for the rc version)

**R package installation:**
```bash
Rscript -e 'install.packages(c("dplyr", "tidyr", "zoo"), repos="https://cran.r-project.org")'
```

## Usage

```bash
./valanza.sh weight.txt
```

or

```bash
./valanza.rc weight.txt
```

## How It Works

1. **interpolate_lin.R** - Fills gaps in weight data
2. **mov_avg.awk** - Computes moving average
3. **lp1.awk** - Applies first-order low-pass filter
4. **gnuplot** - Visualizes all signals

Data flows through named pipes in RAM (when possible). Process substitution splits the stream into parallel filters, then `paste` recombines them.
