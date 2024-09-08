import pandas as pd

def load_species_mapping(txt_file):
    """
    Load the species name mapping from a text file.
    """
    df = pd.read_csv(txt_file, delimiter='\t')
    mapping = pd.Series(df['code'].values, index=df['taxa']).to_dict()
    return mapping

def replace_species_in_file(tree_file_path, mapping, output_file_path):
    """
    Replace species names directly in the file without altering its structure or format.
    """
    with open(tree_file_path, 'r') as file:
        content = file.read()
    
    # Replace all matching full names with abbreviations
    for full_name, abbreviation in mapping.items():
        content = content.replace(full_name, abbreviation)
    
    with open(output_file_path, 'w') as file:
        file.write(content)

# Example usage
tree_path = 'd:/BIOL8706_project/data/36794inter_mix_result/36794_mix_combined.treefile'  # Replace with your tree file path
txt_path = 'd:/naturebird/data/mapping.txt'  # Mapping file path
output_tree_path = 'd:/BIOL8706_project/data/36794inter_mix_result/36794_mix_combined_abrv.treefile'  # Output file path

# Load mapping
mapping = load_species_mapping(txt_path)

# Replace species names and save to a new file
replace_species_in_file(tree_path, mapping, output_tree_path)
