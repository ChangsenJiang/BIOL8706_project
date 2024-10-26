import os
import csv

# Specify the folder path containing .iqtree files
folder_path = 'd:/BIOL8706_project/data/4255exon_mix_result_new'  # Change this to your folder path
# Define the name of the output CSV file
output_csv = 'd:/BIOL8706_project/data/4255exon_mix_msummary/4255exon_mix_msummary.csv'


with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['ID', 'Mixture Model', 'Model Count'])

    # Traverse the specified folder
    for filename in os.listdir(folder_path):
        if filename.endswith('.iqtree'):
            # Extract the ID from the filename
            file_id = filename.split('.')[0]
            # Open and read the file
            with open(os.path.join(folder_path, filename), 'r', encoding='utf-8') as file:
                for line in file:
                    if 'Mixture model of substitution:' in line or 'Model of substitution:' in line:
                        # Extract the content following 'Mixture model of substitution:' or 'Model of substitution:'
                        mixture_model = line.split(': ')[1].strip()
                        # Determine the model count
                        if 'MIX' in mixture_model:
                            # Count the number of commas in the brackets after "MIX" and add 1
                            model_count = mixture_model.count(',') + 1
                        else:
                            # If "MIX" is not present, the count is 1
                            model_count = 1
                        # Write to the CSV file
                        writer.writerow([file_id, mixture_model, model_count])
                        break  # Exit the loop after finding the line, proceed to the next file