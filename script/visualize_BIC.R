# Load necessary libraries
library(ggplot2)
library(dplyr)
library(gridExtra)
library(grid) 
# Read the data from the CSV file
data <- read.csv("D:/BIOL8706_project/data/4255exon_modelfinder_result/BIC_ID.csv")

# Convert 'MIX_MF' to numeric if it's not already
data$MIX_MF <- as.numeric(as.character(data$MIX_MF))
data$MF_MIX <- -data$MIX_MF


data %>% select(MIX_MF) %>% filter(MIX_MF > 0) %>% nrow()

data <- data %>%
  mutate(Condition = ifelse(MIX_MF > 0, "BIC_MIX > BIC_MF", "BIC_MIX < BIC_MF")) 

# Add a row index to create a x-axis for plotting
data$x <- seq_along(data$MIX_MF)

# Create a plot with ggplot2
p1 <- ggplot(data, aes(x = seq_along(MIX_MF), y = MIX_MF, fill = Condition)) +
  geom_col(aes(width = ifelse(MIX_MF > 0, 10, 0.7)), alpha = 0.9) +
  coord_cartesian(ylim = c(-150, 100)) +
  scale_fill_manual(values = c("BIC_MIX > BIC_MF" = "cornflowerblue", "BIC_MIX < BIC_MF" = "grey")) +
  theme_minimal() +
  labs(title = "MixtureFinder-ModerFinder BIC Difference", x = "Exon loci", y = "BIC MIX - BIC MF") +
  theme(legend.title = element_blank(), legend.position = "right")  # Customize the legend appearance

# Create a density plot with ggplot2
p2 <- ggplot(data, aes(x = MIX_MF)) +  # Plot density for MF_MIX
  geom_density(alpha = 0.5, adjust = 1, fill = "cornflowerblue") +  
  geom_vline(xintercept = 0, linetype = "solid", size = 1, color = "red") + 
  coord_cartesian(xlim = c(-200, 120))+# Use blue for the whole density
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  labs(title = "Density Plot of MixtureFinder-ModerFinder BIC Difference", x = "BIC Difference", y = "Density")

# Print the plot in RStudio
combined_plot <- grid.arrange(p1, p2, nrow = 2)

# Add text annotation to the second plot
grid.text("- Only 24 of 4255 loci (0.56%) ", x = 0.72, y = 0.3, just = "left", gp = gpar(font = 3))
grid.text("have a BIC difference > 0.", x = 0.73, y = 0.27, just = "left", gp = gpar(font = 3))