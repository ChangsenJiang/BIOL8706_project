def set_terminal_branch_lengths(newick, length=1):
    import re
    
    # Compile a regular expression pattern to find terminal node names in the Newick format
    pattern = re.compile(r'(\b\w+_\w+\b)(?=\s*[\),])')

    # Function to replace the matched species name with a branch length
    def replacer(match):
        species_name = match.group(1)
        return f'{species_name}:{length}'

    # Use regex to substitute terminal node names with the species name and branch length
    modified_newick = re.sub(pattern, replacer, newick)
    return modified_newick

# Example Newick tree
newick_tree = "(CALSQU:NaN,(GALGAL:NaN,(ALELAT:NaN,(CHATOR:NaN,((PHORUB:NaN,(PODCRI:NaN,PODPOD:NaN)1:6.907854972)1:3.001799934,(((((ACACHL:NaN,(((CNELOR:NaN,PROCAF:NaN)1:11.71271439,MENNOV:NaN)1:6.904429497,SERLUN:NaN)1:2.585270683)1:7.216284696,CHUBUR:NaN)1:0.1416387671,UROIND:NaN)1:0.7628907991,(((PHALEP:NaN,CICMAG:NaN)1:0.030836073,NYCLEU:NaN)0.9:0.01069899951,(OPIHOA:NaN,PSOCRE:NaN)0.88:0.006094478)1:0.01076280466)1:0.02749010469,((MESUNI:NaN,COLPIC:NaN)1:0.03077108739,(TAUERY:NaN,(LOPRUF:NaN,CROSUL:NaN)1:0.02089502944)1:0.0729904691)1:0.02937276104)1:0.0258800025)1:12.79455858)1:6.769615207)1:12.72358458)1:14.76399225);"

# Set the terminal branch lengths to 1
modified_newick_tree = set_terminal_branch_lengths(newick_tree)
print(modified_newick_tree)


def replace_nan_with_one(newick):
    import re

    # Compile a regular expression pattern to match 'NaN'
    pattern = re.compile(r'\bNaN\b')

    # Function to replace 'NaN' with '1.0'
    def replacer(match):
        return '1.0'

    # Use regex to replace all occurrences of 'NaN' with '1.0'
    modified_newick = re.sub(pattern, replacer, newick)
    return modified_newick

# Example usage
newick_data = "((((ACACHL:NaN,(((CNELOR:NaN,PROCAF:NaN)1:3.001752776,MENNOV:NaN)1:1.509683034,SERLUN:NaN)1:0.604245638)1:2.067589718,UROIND:NaN)1:0.148852821,((((((OPIHOA:NaN,(((PHALEP:NaN,CICMAG:NaN)1:0.04131018882,(PHORUB:NaN,(PODCRI:NaN,PODPOD:NaN)1:2.260313748)1:0.8283564318)1:0.04805092056,PSOCRE:NaN)0.96:0.0260112124)0.88:0.01631740764,NYCLEU:NaN)0.59:0.03428343798,(TAUERY:NaN,LOPRUF:NaN)0.93:0.01747262677)0.29:0.06108640605,((ALELAT:NaN,(CALSQU:NaN,GALGAL:NaN)1:3.676734836)1:1.44291438,CHATOR:NaN)1:2.763350674)1:0.04661710224,CROSUL:NaN)0.45:0.003460842161,(MESUNI:NaN,COLPIC:NaN)1:0.02944782751)1:0.1215297476)1:0.1064605202,CHUBUR:NaN);"

# Replace all 'NaN' with '1.0'
modified_newick = replace_nan_with_one(newick_data)
print(modified_newick)
