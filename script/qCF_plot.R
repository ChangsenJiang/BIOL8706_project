# Load necessary libraries
library(stringr)

# Get all .tree files from the specified directory
tree_files <- list.files(path = "D:/BIOL8706_project/data/mass/qcf_astral_boxplot", pattern = "\\.tree$", full.names = TRUE)
tree_files

# Initialize an empty list to store the q1 values from each file
q1_list <- list()

# Loop through each .tree file
for (file in tree_files) {
  # Read the content of the file
  file_content <- readLines(file, warn = FALSE)
  
  # Merge the file content into a single string
  file_content_str <- paste(file_content, collapse = " ")
  
  # Use a regular expression to extract all q1 values (only capturing q1, ignoring q2, q3, etc.)
  q1_values <- str_match_all(file_content_str, "\\[q1=([0-9\\.]+);")[[1]][, 2]
  
  # Store the extracted q1 values in the list
  q1_list[[file]] <- as.numeric(q1_values)
}

# Convert the list into a data frame, with each file as a column
df <- do.call(cbind, q1_list)

# Set the column names as the file names
colnames(df) <- basename(tree_files)

# Load necessary libraries
library(ggplot2)
library(reshape2)

# Modify the column names in df to the specified names
colnames(df) <- c("Intergenic_ModelFinder", "Intergenic_MixtureFinder", "Exon_ModelFinder", "Exon_MixtureFinder")

# Reshape the data frame into long format to facilitate plotting multiple boxplots
df_long <- melt(df)

# Create a new variable 'Region' to distinguish between Intergenic and Exon regions
df_long$Region <- ifelse(df_long$Var2 %in% c("Intergenic_ModelFinder", "Intergenic_MixtureFinder"), "Intergenic", "Exon")

# Load necessary libraries
library(ggplot2)

# Calculate the density for each group
df_intergenic_model <- density(df_long$value[df_long$Var2 == "Intergenic_ModelFinder"])
df_intergenic_mix <- density(df_long$value[df_long$Var2 == "Intergenic_MixtureFinder"])
df_exon_model <- density(df_long$value[df_long$Var2 == "Exon_ModelFinder"])
df_exon_mix <- density(df_long$value[df_long$Var2 == "Exon_MixtureFinder"])

# Create a data frame to merge the density values and their corresponding x-axis values
df_density <- data.frame(
  x = df_exon_model$x,  # Assuming x-axis values are the same
  Intergenic_ModelFinder = df_intergenic_model$y,
  Intergenic_MixtureFinder = df_intergenic_mix$y,
  Exon_ModelFinder = df_exon_model$y,
  Exon_MixtureFinder = df_exon_mix$y
)

# Plot a boxplot with different colors for each group
ggplot(df_long, aes(x = Var2, y = value, fill = Var2)) +
  geom_point() +  # Create a scatter plot
  labs(title = "Q1 Value Distribution Across Different Files",
       x = "File Type",
       y = "Q1 Value") +
  theme_minimal() +
  scale_fill_manual(values = c("darkgreen", "green", "blue", "lightblue")) +  # Manually set colors for each group
  theme(legend.position = "bottom")

# Plot a line plot with points, connecting data points for each file
ggplot(df_long, aes(x = Var2, y = value, group = 1, color = Var2)) +
  geom_line(aes(group = Var1)) +  # Connect points using Var1
  geom_point(size = 3) +  # Add point markers
  labs(title = "Q1 Value Distribution Across Different Files",
       x = "File Type",
       y = "Q1 Value") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("blue", "red", "green", "yellow"))  # Manually set line colors

# Plot a dot plot to show density distribution
ggplot(df_long, aes(x = Var2, y = value, fill = Var2)) +
  geom_dotplot(binaxis = "y", stackdir = "center", dotsize = 0.7) +  # Dot plot for density visualization
  labs(title = "Q1 Value Distribution Across Different Files",
       x = "File Type",
       y = "Q1 Value") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = c("blue", "red", "green", "yellow"))  # Manually set fill colors

# Plot a violin plot to visualize the distribution with jitter points
ggplot(df_long, aes(x = Var2, y = value, fill = Var2)) +
  geom_violin(trim = FALSE, alpha = 0.6) +  # Violin plot to show distribution
  geom_jitter(width = 0.2, size = 2, alpha = 0.6) +  # Add jitter points for more detail
  labs(title = "Q1 Value Distribution Across Different Files",
       x = "File Type",
       y = "Q1 Value") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = c("blue", "red", "green", "yellow"))  # Manually set fill colors
