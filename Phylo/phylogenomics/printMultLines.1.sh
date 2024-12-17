#!/bin/bash

# The string you want to print
your_string="==1 &"

# Number of lines you want to print the string
num_lines=18

# Loop to print the string 18 times
for ((i=0; i<$num_lines; i++)); do
    echo $your_string
done
