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
    header = lines[0].split('_')[:-1]  # Remove last underscore and number
    new_header = '_'.join(header)
    sequence_body = ''.join(lines[1:])
    processed_sequences.append(f'>{new_header}\n{sequence_body}')

# Write updated sequences to the output file
with open(output_file, 'w') as outfile:
    outfile.write('\n'.join(processed_sequences))

print(f"Headers updated and saved to {output_file}")

