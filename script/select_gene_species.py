import os
from Bio import SeqIO
import pandas as pd

def extract_species(fasta_file):
    """Extract all species names from a fasta file."""
    species = set()
    for record in SeqIO.parse(fasta_file, "fasta"):
        species_id = record.id
        species.add(species_id)
    return species

def sytsy(folder_path):
    species_data = {}
    all_species = set()

    # Get all fasta files from the specified directory
    fasta_files = [f for f in os.listdir(folder_path) if f.endswith(".fasta")]
    total_files = len(fasta_files)  
    processed_files = 0  # Count of processed files

    # Traverse all fasta files in the specified folder
    for filename in fasta_files:
        file_path = os.path.join(folder_path, filename)
        species_in_file = extract_species(file_path)
        all_species.update(species_in_file)
        species_data[filename] = species_in_file

        processed_files += 1
        print(f"Processed {processed_files}/{total_files}: {filename}")  # Output progress

    # Create a DataFrame to store the results
    # Columns for all species encountered, rows for each gene (filename)
    species_list = sorted(all_species)  # Sort species names for consistency
    data_matrix = []

    for filename, species_set in species_data.items():
        row = [1 if species in species_set else 0 for species in species_list]
        data_matrix.append(row)

    df = pd.DataFrame(data_matrix, columns=species_list, index=species_data.keys())
    # Save the result to an Excel file
    output_file_path = os.path.join(folder_path, "species_presence_matrix.xlsx")
    df.to_excel(output_file_path)
    print(f"Excel file saved to: {output_file_path}")


sytsy("d:/naturebird/data/14972_exon_alns")