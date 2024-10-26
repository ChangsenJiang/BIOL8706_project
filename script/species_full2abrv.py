import pandas as pd

def load_species_mapping(txt_file):
    """
    Load the species name mapping from a text file.
    """
    df = pd.read_csv(txt_file, delimiter='\t')
    mapping = pd.Series(df['code'].values, index=df['taxa']).to_dict()
    return mapping

def replace_taxa_with_code(tree_file_path, mapping, output_file_path):
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

def replace_codes_with_taxa(tree_file_path, mapping, output_file_path):
    """
    Replace species codes with taxa names directly in the file without altering its structure or format.
    """
    reverse_mapping = {v: k for k, v in mapping.items()}  # Reverse the mapping to replace codes with taxa
    
    with open(tree_file_path, 'r') as file:
        content = file.read()
    
    # Replace all matching codes with full names
    for code, taxa in reverse_mapping.items():
        content = content.replace(code, taxa)
    
    with open(output_file_path, 'w') as file:
        file.write(content)


# Example usage
tree_path = 'd:\BIOL8706_project\data\species_tree/4255combined_newmix_abrv.treefile'  # Replace with your tree file path
txt_path = 'd:/naturebird/data/mapping.txt'  # Mapping file path
output_tree_path = 'd:/BIOL8706_project/data/paper_tree/maintree_terminal1_abrv.treefile'  # Output file path
output_code2full_path = "d:/BIOL8706_project/data/paper_tree/maintree_terminal1_abrv.treefile"
# Load mapping
mapping = load_species_mapping(txt_path)

# Replace species names and save to a new file
#replace_taxa_with_code("d:\BIOL8706_project\data\paper_tree\exon_tree.tree", mapping, "d:\BIOL8706_project\data\paper_tree\exon_tree_abrv.tree")

replace_codes_with_taxa("d:\BIOL8706_project\data\mass\qcf_main_treeplot/4255_maintree_mf_qcfpp.tree", mapping, "d:\BIOL8706_project\data\mass\qcf_main_treeplot/4255_maintree_mf_qcfpp_taxa.tree")
#replace_codes_with_taxa("d:\BIOL8706_project\data\mass/36794inter_mix_result/astral_36794_mix_species.tree", mapping, "d:\BIOL8706_project\data\species_tree/astral_36794_mix_species.tree")