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
#data$x <- seq_along(data$MIX_MF)

# Create a plot with ggplot2
p1 <- ggplot(data, aes(x = seq_along(MIX_MF), y = MIX_MF, fill = Condition)) +
  geom_col(aes(width = ifelse(MIX_MF > 0, 10, 0.7)), alpha = 0.9) +
  coord_cartesian(ylim = c(-150, 100)) +
  scale_fill_manual(values = c("BIC_MIX > BIC_MF" = "cornflowerblue", "BIC_MIX < BIC_MF" = "grey")) +
  theme_minimal() +
  labs(title = "MixtureFinder-ModerFinder BIC Difference in Exon", x = "Exon loci", y = "BIC MIX - BIC MF") +
  theme(legend.title = element_blank(), legend.position = "right")  # Customize the legend appearance

# Create a density plot with ggplot2
p2 <- ggplot(data, aes(x = MIX_MF)) +  # Plot density for MF_MIX
  geom_density(alpha = 0.5, adjust = 1, fill = "cornflowerblue") +  
  geom_vline(xintercept = 0, linetype = "solid", size = 1, color = "red") + 
  coord_cartesian(xlim = c(-200, 100))+# Use blue for the whole density
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 15, face = "bold"),  
        axis.text.y = element_text(size = 15, face = "bold")) + 
  labs(title = "Density Plot of MixtureFinder - ModerFinder BIC Difference", x = "BIC Difference", y = "Density")

# Print the plot in RStudio


# Add text annotation to the second plot
#grid.text("- Only 24 of 4255 loci (0.56%) ", x = 0.72, y = 0.3, just = "left", gp = gpar(font = 3))
#grid.text("have a BIC difference > 0.", x = 0.73, y = 0.27, just = "left", gp = gpar(font = 3))






139/36794
data_inter <- read.csv("D:/BIOL8706_project/data/BIC_inter.csv")
# Process data_inter
data_inter$MIX_MF <- as.numeric(as.character(data_inter$MIX_MF))
data_inter$MF_MIX <- -data_inter$MIX_MF

# Remove rows where MIX_MF equals 0
data_inter <- data_inter %>%
  filter(MIX_MF != 0) %>%
  mutate(Condition = ifelse(MIX_MF > 0, "BIC_MIX > BIC_MF", "BIC_MIX < BIC_MF"))

data_inter %>% select(MIX_MF) %>% filter(MIX_MF > 0) %>% nrow()


# Create bar plot for data_inter

# Create density plot for data_inter
p2_inter <- ggplot(data_inter, aes(x = MIX_MF)) +
  geom_density(alpha = 0.5, adjust = 1, fill = "darkgreen") +  
  geom_vline(xintercept = 0, linetype = "solid", size = 1, color = "red") + 
  coord_cartesian(xlim = c(-200, 100)) +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 15, face = "bold"), 
        axis.text.y = element_text(size = 15, face = "bold")) + 
  labs(x = "BIC Difference", y = "Density")

p2_inter

combined_plot <- grid.arrange(p2, p2_inter, nrow = 2)



# First, ensure both data and data_inter have a common variable to distinguish them
data$Region <- "Exon"
data_inter$Region <- "Intergenic"

# Combine both datasets into one data frame
combined_data <- bind_rows(data, data_inter)

# Create an overlay density plot
combined_plot <- ggplot(combined_data, aes(x = MIX_MF, fill = Region, color = Region)) +
  geom_density(alpha = 0.5, adjust = 1, size = 1.2) +  # Use size parameter to thicken the lines
  geom_vline(xintercept = 0, linetype = "solid", size = 1.2, color = "red") +  # Add a vertical line at x=0
  coord_cartesian(xlim = c(-200, 100)) +  # Set x-axis range
  theme_minimal() +  # Use a clean theme
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 11, face = "bold"), 
        axis.text.y = element_text(size = 11, face = "bold"),
        axis.title.x = element_text(size = 15, face = "bold"),  # Set the size of the x-axis title
        axis.title.y = element_text(size = 18, face = "bold")) + 
  labs(x = "BIC Difference between Mixture Model and One-class model", y = "Density") +
  scale_fill_manual(values = c("Exon" = "cornflowerblue", "Intergenic" = "darkgreen")) +  # Customize fill colors
  scale_color_manual(values = c("Exon" = "cornflowerblue", "Intergenic" = "darkgreen"))  # Match outline colors with fill colors

# Display the overlay plot
print(combined_plot)
