# Load necessary libraries
library(ggplot2)
library(plotly)  # Load the plotly library to use ggplotly()
library(viridis)
library(gridExtra)
# Load the viridis library for colorblind-friendly color palettes

# Read the CSV file
data_exon <- read.csv("D:/BIOL8706_project/data/4255exon_mix_msummary/4255exon_mix_msummary.csv")

# Calculate the number of IDs corresponding to each model count
model_counts_exon <- table(data_exon$Model_Count)

# Convert to a data frame for plotting
model_counts_exon_df <- as.data.frame(model_counts_exon)
names(model_counts_exon_df) <- c("Number_of_models", "Frequency")

# Read the CSV file
data <- read.csv("D:/BIOL8706_project/data/4255exon_mix_msummary/36794inter_mix_msummary.csv")

# Calculate the number of IDs corresponding to each model count
model_counts <- table(data$Model_Count)

# Convert to a data frame for plotting
model_counts_df <- as.data.frame(model_counts)
names(model_counts_df) <- c("Number_of_models", "Frequency")

# Calculate the maximum y-value for consistent scaling between plots
max_y_value <- max(model_counts_df$Frequency / 36794)

# Create a bar plot with frequency labels on top
p1 <- ggplot(model_counts_exon_df, aes(x = Number_of_models, y = Frequency / 4255, fill = Frequency)) +  # Fill color depends on Frequency
  geom_bar(stat = "identity", color = "black") +
  geom_text(aes(label = scales::percent(Frequency / 4255, accuracy = 0.01)), vjust = -0.5, color = "black") +  # Add text labels above each bar
  labs(title = "Exon",
       x = "Number of Models",
       y = "Relative frequency") +
  theme_minimal() +
  theme(strip.text.y = element_text(size = 11, face = "bold", colour = "black"),
        axis.text = element_text(size = 11, face = "bold"),  # Labels for x and y axes
        axis.title = element_text(size = 13, face = "bold"))+  # Axis titles
  ylim(0, max_y_value) +
  scale_fill_gradient(low = "lightblue", high = "#1F7A8C")  # Use a colorblind-friendly viridis palette, deeper colors for higher frequencies

p1

# Create a bar plot with frequency labels on top
p <- ggplot(model_counts_df, aes(x = Number_of_models, y = Frequency / 36794, fill = Frequency)) +  # Fill color depends on Frequency
  geom_bar(stat = "identity", color = "black") +
  geom_text(aes(label = scales::percent(Frequency / 36794, accuracy = 0.01)), vjust = -0.5, color = "black") +  # Add text labels above each bar
  labs(title = "Intergenic Region",
       x = "Number of Models",
       y = "Relative Frequency") +
  theme_minimal() +
  theme(strip.text.y = element_text(size = 11, face = "bold", colour = "black"),
        axis.text = element_text(size = 11, face = "bold"),  # Labels for x and y axes
        axis.title = element_text(size = 13, face = "bold"))+  # Axis titles
  ylim(0, max_y_value) +
  scale_fill_gradient(low = "lightgreen", high = "darkgreen")  # Use a colorblind-friendly viridis palette, deeper colors for higher frequencies

# Arrange the two plots side by side
grid.arrange(p1, p, ncol = 2)
