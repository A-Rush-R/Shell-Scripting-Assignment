#!/bin/bash

dashes() {
    echo "------------------" >> $outfile  # Append dashes to the output file
}

# function to calculate average salary for a given city
calculate_average() {
    local infile="$1"
    local outfile="$2"
    local city="$3"

    # Calculate the average of the 4th column for records matching the given city
    # maintain count to keep track of number of records for finding the average
    average=$(awk -F', ' -v c="$city" '$3 == c {sum += $4; count++} END {print sum/count}' "$infile")

    echo "City: $city, Salary: $average" >> $outfile
}

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
awk -F ', ' 'NR>1 {print $3}' $infile | sort | uniq >> $outfile

dashes
echo Details of top 3 individuals with the highest salary: >> $outfile
# sort (excluding the header) along the 4th column in reverse order and then print the first three entries
awk -F',' 'NR>1 {print $0}' $infile | sort -t',' -k4r | awk -F',' 'NR<4 {print}' >> $outfile

# Logic for top 3 individuals

dashes
echo Details of average salary of each city: >> $outfile

# find the unique cities (removing the header)
unique_cities=$(awk -F ', ' 'NR>1 {print $3}' $infile | sort | uniq)

# Iterate over each unique city and calculate average
# unique_cities acts as input to the while loop
while IFS= read -r city; do
    calculate_average $infile $outfile "$city"
done <<< "$unique_cities"

dashes 
echo Details of individuals with a salary above the overall average salary: >> $outfile

# First we find the average salary
# Remove the ', ' as the delimiter, extract the salaries and then loop over them to find the sum
# Then divide by number of records (NR-1, accounting for the header) to find the header
average=$(awk -F', ' '{print $4}' $infile | awk '{sum += $1} END {print sum/(NR-1)}')

# Next we filter the records where the salary is greater than average 
# Remove ',' as the delimiter, remove the header and then print if salary is greater than average
awk -v avg="$average" -F',' 'NR > 1 && $4 > avg {print}' $infile >> $outfile

dashes