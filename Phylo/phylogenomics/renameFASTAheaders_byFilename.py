#!/usr/bin/env python


import argparse
import argcomplete
from Bio import SeqIO

## run as: python3 renameFASTAheaders_byFilename.py -f [input] > [output]

parser = argparse.ArgumentParser(description='Provide sequence lengths')
parser.add_argument('-f', '--fasta', help='Path to input FASTA(s)', nargs='+', type=str, required=True)

#argcomplete.autocomplete(parser) ## still does not autocomplete

args = parser.parse_args()

fasta_files = args.fasta

for fasta_file in fasta_files:
    with open(fasta_file, "r") as file:
        name = (fasta_file.split(".")[0]) ## get the name of the fasta file
        c=0
        for seq_record in SeqIO.parse(file, "fasta"):
            c += 1
            print(">" + name + "_" + str(c) + "\n" + seq_record.seq)
            




