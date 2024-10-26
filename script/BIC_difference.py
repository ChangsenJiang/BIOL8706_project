import os
import re

def extract_bic_scores_from_folder(folder_path):
    bic_scores = []
    for filename in os.listdir(folder_path):
        if filename.endswith(".iqtree"):
            file_path = os.path.join(folder_path, filename)
            with open(file_path, 'r') as file:
                for line in file:
                    if "Bayesian information criterion (BIC) score:" in line:
                        # Extract the numeric value from that line
                        score = line.split(":")[1].strip()
                        bic_scores.append(score)
                        break  # Assume each file has only one BIC score
    return bic_scores

def extract_bic_values_from_specific_file(file_path, start_line, end_line):
    bic_values = []
    with open(file_path, 'r') as file:
        for i, line in enumerate(file, 1):
            if i >= start_line and i <= end_line:
                values = line.split()
                # Based on new information, the BIC value is the third-to-last value
                bic_values.append(values[-3])
    return bic_values


def extract_file_ids(folder_path):
    file_ids = []
    for filename in os.listdir(folder_path):
        match = re.search(r'_(R\d+).fa', filename)
        if match:
            file_ids.append(match.group(1))
    return file_ids

# Set folder path and specific file path
folder_path = 'd:\BIOL8706_project\data\mass/36794inter_mix_result'
specific_file_path = 'd:\BIOL8706_project\data\mass/36794inter_mf_result/36794inter_mf_result\mf_combined.iqtree'
#folder_path_ids = "d:/BIOL8706_project/data/4255exon"
# Part 1: Extract BIC scores from all .iqtree files in the folder
bic_scores = extract_bic_scores_from_folder(folder_path)

# Part 2: Extract BIC values from specified lines in a specific file
bic_values = extract_bic_values_from_specific_file(specific_file_path, 36847, 73640)


#file_ids = extract_file_ids(folder_path_ids)

# Output to a CSV file
import pandas as pd

df = pd.DataFrame({
#    'File IDs': file_ids,
    'BIC Scores from Folder': bic_scores,
    'BIC Values from Specific File': bic_values
})

output_file_path = 'd:/BIOL8706_project/data/BIC_inter.csv'

# Save DataFrame to CSV without row index
df.to_csv(output_file_path, index=False)
