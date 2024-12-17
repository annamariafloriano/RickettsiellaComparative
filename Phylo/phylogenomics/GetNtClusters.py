import sys
import os
import shutil

# Define the paths to Directory1 and Directory2
aacluster_path = sys.argv[1]
allnt_path = sys.argv[2]
output_directory_path = sys.argv[3]

# Create Directory3 if it doesn't exist
if not os.path.exists(output_directory_path):
    os.makedirs(output_directory_path)

# Dictionary to store nucleotide sequences based on headers
sequence_dict = {}

# Read nucleotide sequences from files in Directory2 and store them in sequence_dict
for organism_file in os.listdir(allnt_path):
    organism_file_path = os.path.join(allnt_path, organism_file)
    with open(organism_file_path, 'r') as file:
        lines = file.readlines()
        header = None
        sequence = ''
        for line in lines:
            if line.startswith('>'):
                if header is not None:
                    sequence_dict[header] = sequence
                header = line.strip()
                sequence = ''
            else:
                sequence += line.strip()
        # Add the last sequence in the file
        if header is not None:
            sequence_dict[header] = sequence

# Process files in Directory1 and create corresponding files in Directory3
for cluster_file in os.listdir(aacluster_path):
    cluster_file_path = os.path.join(aacluster_path, cluster_file)
    output_file_path = os.path.join(output_directory_path, cluster_file)
    
    with open(cluster_file_path, 'r') as cluster_file_content, open(output_file_path, 'w') as output_file:
        lines = cluster_file_content.readlines()
        for line in lines:
            header = line.strip()
            # If header exists in sequence_dict, write the sequence to Directory3
            if header in sequence_dict:
                output_file.write(header + '\n')
                output_file.write(sequence_dict[header] + '\n')

# Inform the user that the operation is completed
print("Directory has been created with the required cluster and nucleotide sequence data.")

