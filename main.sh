#!/bin/bash

dashes() {
    echo "------------------" >> $outfile  # Append dashes to the output file
}

echo Hello World

if [ $# -ne 2 ] 
then
    echo Usage : Please provide exactly two filenames
    exit 101
fi

if [ ! -f $1 ]
then 
    echo Error : The given file does not exist
    exit 404
fi

infile=$1
outfile=$2

# create output file (ignore if already present)
touch $outfile

# clear output file
> $outfile

# append dashes
dashes

# append first message
echo Unique cities in the given data file:  >> $outfile

# -F ', ' removes the comma and space between the values
# 'NR>1 {print $3}' retrieves the third column of the record, removing the header
# then we sort them and then remove adjacent duplicates using uniq
# awk -F ', ' 'NR>1 {print $3}' data.csv | awk '!x[$0]++' >> $outfile
# awk -F ', ' 'NR>1 {if (!seen[$3]++) print $3}' data.csv >> $outfile
awk -F ', ' 'NR>1 {print $3}' data.csv | sort | uniq >> $outfile

dashes
echo Details of top 3 individuals with the highest salary: >> $outfile

# Logic for top 3 individuals

dashes
echo Details of average salary of each city: >> $outfile

# Logic for avcerage salary

dashes 
echo Details of individuals with a salary above the overall average salary: >> $outfile

# Logic for individuals with salary above overall average

dashes