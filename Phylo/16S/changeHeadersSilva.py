import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

# Read input FASTA file
with open(input_file, 'r') as infile:
    data = infile.read()

# Split the data into individual sequences
sequences = data.split('>')[1:]

# Process each sequence and update the header
processed_sequences = []
for sequence in sequences:
    lines = sequence.split('\n')
    header = lines[0].split(' ')[0]  # Keep only the first part of the header before the first space
    sequence_body = '\n'.join(lines[1:])  # Join the sequence lines back with newlines
    processed_sequences.append(f'>{header}\n{sequence_body}')

# Write updated sequences to the output file
with open(output_file, 'w') as outfile:
    outfile.write('\n'.join(processed_sequences))

print(f"Headers updated and saved to {output_file}")

