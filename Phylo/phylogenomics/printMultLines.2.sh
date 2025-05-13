#!/bin/bash

# The string you want to print
your_string="cp ../Results_May16/Orthogroup_Sequences/"

# Number of lines you want to print the string
num_lines=109

# Loop to print the string 109 times
for ((i=0; i<$num_lines; i++)); do
    echo $your_string
done
