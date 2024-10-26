library(ggplot2)
library(dplyr)
library(tidyr)

# Set the folder path containing the .rfdist files
folder_path <- "D:/BIOL8706_project/data/mass/rftest"

# Get the paths of all .rfdist files in the folder
file_paths <- list.files(path = folder_path, pattern = "\\.rfdist$", full.names = TRUE)

# Initialize an empty data frame to store all the data
# First, determine the maximum number of rows
max_length <- 0
for (file_path in file_paths) {
  file_data <- read.table(file_path, skip = 1, header = FALSE, colClasses = "character")
  if (nrow(file_data) > max_length) {
    max_length <- nrow(file_data)
  }
}

# Initialize the data frame based on the maximum number of rows
results_df <- data.frame(matrix(ncol = 0, nrow = max_length))

# Iterate through each file path
for (file_path in file_paths) {
  # Read the file content, skipping the first line
  file_data <- read.table(file_path, skip = 1, header = FALSE, colClasses = "character")
  
  # Convert the second column from character to numeric
  numbers <- as.numeric(file_data$V2)
  
  # Fill missing values to match the maximum length
  filled_numbers <- c(numbers, rep(NA, max_length - length(numbers)))
  
  # Use the file name (removing path and extension) as the column name
  column_name <- gsub(pattern = ".*/|\\.rfdist$", replacement = "", x = file_path)
  results_df[[column_name]] <- filled_numbers
}

# View the results
print(results_df)
# Assuming your data frame is named df
colnames(results_df) <- c("36794_ModelFinder", "36794_MixtureFinder", "4255_ModelFinder", "4255_MixtureFinder")

# Reshape the data into long format
df_long <- results_df %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "value") %>%
  separate(variable, into = c("number", "group"), sep = "_") %>%
  mutate(subgroup = ifelse(grepl("36794", number), "Intergenic", "Exon"))

# View the transformed data
print(df_long)

# Remove rows with NA values
df_clean <- df_long %>%
  filter(!is.na(value))

# Calculate median and quartiles for each group
summary_stats <- df_long %>%
  group_by(group, subgroup) %>%
  summarise(
    median_value = median(value, na.rm = TRUE),
    lower_quartile = quantile(value, 0.25, na.rm = TRUE),
    upper_quartile = quantile(value, 0.75, na.rm = TRUE)
  )

# Check the number of data points in each group
df_clean %>% 
  group_by(group, subgroup) %>% 
  summarise(
    count = n(),
    min_value = min(value, na.rm = TRUE),
    q1 = quantile(value, 0.25, na.rm = TRUE),
    median = median(value, na.rm = TRUE),
    q3 = quantile(value, 0.75, na.rm = TRUE),
    max_value = max(value, na.rm = TRUE)
  )

# Calculate the probability of each RF value
df_probability <- df_clean %>%
  group_by(subgroup, group, value) %>%            # Group by subgroup, group, and RF value
  summarise(count = n(), .groups = 'drop') %>%    # Count occurrences of each RF value
  group_by(subgroup, group) %>%                   # Group again by subgroup and group
  mutate(total = sum(count)) %>%                  # Calculate total occurrences in each group
  mutate(probability = count / total) %>%
  mutate(value = value / 42) %>%  # Normalize the value by dividing by 42
  ungroup()                                       # Remove grouping

# Plot a bar chart where bar height represents probability
p <- ggplot(data = df_probability, aes(x = value, y = probability, fill = group)) +
  geom_col(position = position_dodge(), alpha = 0.7, color = "black", size = 0.6) +
  facet_grid(subgroup ~ ., scales = "free_y") +  # Use facet_grid to split by subgroup
  labs(x = "Robinson-Foulds distance",
       y = "Relative Frequency") +
  theme_minimal() +  # Use a clean theme
  theme(strip.text.y = element_text(size = 11, face = "bold", colour = "black"),
        axis.text = element_text(size = 11, face = "bold"),  # Labels for x and y axes
        axis.title = element_text(size = 13, face = "bold"))+  # Axis titles
  scale_fill_manual(values = c("ModelFinder" = "darkgrey", "MixtureFinder" = "darkgreen"))  # Customize fill colors

# Display the plot
print(p)
