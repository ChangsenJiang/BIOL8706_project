import os
from Bio import SeqIO
from collections import defaultdict

def filter_fasta_files(input_dir, output_dir, species_list, min_species_count=4):
    """
    Filters FASTA files in a given directory, selecting only sequences that belong to a specified list of species.
    Writes the filtered sequences to new FASTA files in a different directory only if at least four of the specified species are present.

    Parameters:
        input_dir (str): The directory containing the original FASTA files.
        output_dir (str): The directory where filtered FASTA files will be saved.
        species_list (list): A list of species identifiers to filter the sequences.
        min_species_count (int): Minimum number of different species required to include the file in the output.
    """
    # Create the output directory if it does not exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Iterate over all files in the input directory
    for file_name in os.listdir(input_dir):
        if file_name.endswith('.fasta'):
            input_path = os.path.join(input_dir, file_name)
            
            # Read the FASTA file
            with open(input_path, 'r') as input_file:
                records = SeqIO.parse(input_file, 'fasta')
                species_count = defaultdict(int)
                filtered_records = []

                for record in records:
                    species_in_record = [species for species in species_list if species in record.description]
                    if species_in_record:
                        # Update the count for each species found in the record
                        for species in species_in_record:
                            species_count[species] += 1
                            if species_count[species] == 1:  # Only add the record once per species
                                filtered_records.append(record)

                # Check if the file contains at least the minimum number of different species
                if sum(1 for count in species_count.values() if count > 0) >= min_species_count:
                    output_path = os.path.join(output_dir, file_name)
                    with open(output_path, 'w') as output_file:
                        SeqIO.write(filtered_records, output_file, 'fasta')
                    print(f"File written: {file_name} with at least {min_species_count} of the specified species.")
                else:
                    print(f"File skipped: {file_name} does not meet the minimum species requirement.")

# Specify the input and output folder paths
input_dir = 'd:/naturebird/data/14972_exon_alns'
output_dir = 'd:/BIOL8706_project/data/species_filter/species_filtered_newlogic'  # A new subdirectory for filtered files

# Specify the list of species to be filtered
species_list = ["PROCAF", "CNELOR", "MENNOV", "SERLUN", "ACACHL", "CHUBUR", "UROIND", "CICMAG", 
                "PHALEP", "NYCLEU", "PSOCRE", "OPIHOA", "CROSUL", "LOPRUF", "TAUERY", "COLPIC",
                "MESUNI", "PODCRI", "PODPOD", "PHORUB", "CALSQU", "CHATOR", "ALELAT", "GALGAL"]

# Call the function
filter_fasta_files(input_dir, output_dir, species_list)
