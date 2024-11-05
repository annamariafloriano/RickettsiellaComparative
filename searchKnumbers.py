import os


def process_files(kegg_ids_file, output_file):
    # Read KEGG IDs from the input file
    kegg_ids = []
    with open(kegg_ids_file, 'r') as kegg_file:
        kegg_ids = [line.strip() for line in kegg_file]

    # Get a list of annotation files in the current directory
    annotation_files = [file for file in os.listdir('.') if file.endswith('.txt')]
    results = {}

    # Process each KEGG ID
    for kegg_id in kegg_ids:
        results[kegg_id] = {}

        # Check each annotation file for the presence of the KEGG ID
        for file_name in annotation_files:
            with open(file_name, 'r') as annotation_file:
                lines = annotation_file.readlines()
                # Extract the values from the second column of the annotation file
                annotation_values = set(line.split()[1] if len(line.split()) > 1 else "" for line in lines if line.strip())
                # Store "YES" or "NO" based on the presence of the KEGG ID
                results[kegg_id][file_name] = "YES" if kegg_id in annotation_values else "NO"

    with open(output_file, 'w') as out:
        # Write header row with annotation file names
        out.write("K_numbersYES\t")
        for file_name in annotation_files:
            out.write(file_name[:-4] + '\t')  # Remove ".txt" extension (using string slicing to remove the last 4 characters)
        out.write('\n')

        # Write data rows for each KEGG ID
        for kegg_id in kegg_ids:
            out.write(f"{kegg_id}\t")
            # Write "YES" or "NO" for each annotation file
            for file_name in annotation_files:
                out.write(f"{results[kegg_id][file_name]}\t")
            out.write('\n')

if __name__ == "__main__":
    # Get input and output file paths from user input
    kegg_ids_file = input("Enter the path to the KEGG IDs file: ")
    output_file = input("Enter the desired output file name: ")

    # Process files and print a message indicating where the output is saved
    process_files(kegg_ids_file, output_file)
    print(f"Output written to {output_file}")
