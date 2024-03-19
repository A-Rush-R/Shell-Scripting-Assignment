#!/bin/bash

infile=data.csv
outfile=testout.txt

awk -F',' 'NR>1 {print $0}' $infile | sort -t',' -k4r | awk -F',' 'NR<4 {print}' > $outfile
