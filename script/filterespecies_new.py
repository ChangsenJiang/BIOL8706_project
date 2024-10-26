import os
from Bio import SeqIO
from collections import defaultdict

def filter_fasta_files(input_dir, output_dir, species_list):
    """
    Filters FASTA files in a given directory, selecting only sequences that contain all specified species.
    Writes the filtered sequences to new FASTA files in a different directory only if all species are present.

    Parameters:
        input_dir (str): The directory containing the original FASTA files.
        output_dir (str): The directory where filtered FASTA files will be saved.
        species_list (list): A list of species identifiers to ensure presence in the filtered files.
    """
    # Create the output directory if it does not exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # Iterate over all files in the input directory
    for file_name in os.listdir(input_dir):
        if file_name.endswith('.fasta'):
            input_path = os.path.join(input_dir, file_name)
            
            # Read and potentially filter the FASTA file
            with open(input_path, 'r') as input_file:
                records = SeqIO.parse(input_file, 'fasta')
                species_presence = defaultdict(int)
                filtered_records = []
                
                for record in records:
                    # Update species presence count
                    for species in species_list:
                        if species in record.description:
                            species_presence[species] += 1
                            filtered_records.append(record)
                            break

                # Check if all species are present
                if all(species_presence[species] > 0 for species in species_list):
                    output_path = os.path.join(output_dir, file_name)
                    with open(output_path, 'w') as output_file:
                        SeqIO.write(filtered_records, output_file, 'fasta')
                    print(f"File written: {file_name} with all specified species.")
                else:
                    print(f"Missing some species in {file_name}, skipping file.")

# Specify the input and output folder paths
input_dir = 'd:/naturebird\data/63k_alns'
output_dir = 'd:\BIOL8706_project\data\species_filter\Intergenic_species_filtered'  # A new subdirectory for filtered files

# Specify the list of species to be filtered
species_list = ["PROCAF", "CNELOR", "MENNOV", "SERLUN", "ACACHL", "CHUBUR", "UROIND", "CICMAG", 
                "PHALEP", "NYCLEU", "PSOCRE", "OPIHOA", "CROSUL", "LOPRUF", "TAUERY", "COLPIC",
                "MESUNI", "PODCRI", "PODPOD", "PHORUB", "CALSQU", "CHATOR", "ALELAT", "GALGAL"]  # Example species list

# Call the function
filter_fasta_files(input_dir, output_dir, species_list)


