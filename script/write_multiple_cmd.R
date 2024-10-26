library(parallel)

# This script generates batch commands for running iqtree2 based on gene files in a specified folder.
# It also parallelizes the execution of these commands using multiple cores in R (However I didn't use it)


getwd()  # Print the current working directory

# Set the directory path containing .fasta files
folder_path <- "../data/species_filter/example_species_filtered_400loci"

# Get a list of all .fasta files in the folder
file_list <- list.files(path = folder_path, pattern = "\\.fasta$", full.names = TRUE)
file_list

# Generate iqtree2 command line instructions
commands <- sapply(file_list, function(file_list) {
  file_name <- basename(file_list)
  parts <- unlist(strsplit(file_name, "_"))
  gene_name_part <- parts[2]
  gene_name <- unlist(strsplit(gene_name_part, "\\."))[1]
  paste("iqtree2 -s", file_name, "-m MIX+MF -T 2", "-mset GTR -pre", gene_name)
})

# Write the commands to a file
writeLines(commands, "iqtree_commands.txt")



# Parallel process 
# (do not use unless you want to do the parallel process in R)
# Create a cluster using available cores minus one
cl <- makeCluster(detectCores() - 1) 

# Function to run a command and capture the output
run_command <- function(cmd) {
  system(cmd, intern = TRUE)  # intern = TRUE captures the output
}

# Execute commands in parallel and collect results
results <- parLapply(cl, commands, run_command)
stopCluster(cl)  # Stop the cluster
