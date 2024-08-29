library(parallel)

# Set the directory path containing .fasta files
folder_path <- "../data/species_filter/species_filtered"

# Get a list of all .fasta files in the folder
file_list <- list.files(path = folder_path, pattern = "\\.fasta$", full.names = TRUE)

# Generate iqtree2 command line instructions
commands <- sapply(file_list, function(file_path) {
  # Extract the base file name without the directory path and extension
  file_name <- basename(file_path)
  
  # Extract gene name from the file name (assuming format like 'GALGAL_R00006.fa.nt_ali.filtered.fasta')
  gene_name <- sub(".*_(R\\d+).*", "\\1", file_name)
  
  # Construct the full command using specific paths and options
  cmd <- sprintf("/data/changsen/bin/iqtree2 -s /data/changsen/4255exon/%s -m MIX+MF -T 1 -mset GTR -pre /data/changsen/4255exon_result/%s",
                 file_name, gene_name)
  return(cmd)
})

# Write the commands to a file, ensuring Unix line endings
writeLines(commands, "iqtree_commands.txt", useBytes = TRUE)
