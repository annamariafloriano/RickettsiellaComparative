#!/bin/bash

# The string you want to print
your_string="cp ../Results_May16/Orthogroup_Sequences/"

# Number of lines you want to print the string
num_lines=92

# Loop to print the string 92 times
for ((i=0; i<$num_lines; i++)); do
    echo $your_string
done
