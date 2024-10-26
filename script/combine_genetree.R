# This script takes a folder path
# And it combines all .treefile outputs in that folder into a single treefile for subsequent ASTRAL analysis.

folder_path <- "D:/BIOL8706_project/data/100exonfull_mix_result"

# Get a list of all .treefile files in the folder
tree_files <- list.files(path = folder_path, pattern = "\\.treefile$", full.names = TRUE)
output_file_path <- file.path(folder_path,  "100full_mix_combined.treefile")

# If the output file already exists, delete it
if (file.exists(output_file_path)) {
  file.remove(output_file_path)  # If the file exists, delete it
}

# Read content from each tree file and append it to the output file
for (tree_file in tree_files) {
  content <- readLines(tree_file)
  # Append content to the combined tree file
  cat(content, file = output_file_path, append = TRUE, sep = "\n")
}
