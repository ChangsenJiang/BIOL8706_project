library(tidyverse)
library(ggtree)
library(ape)
library(ggtree)
library(gridExtra)
library(dendextend)

# Read your tree files (.tree files)
tree3 <- read.tree("D:/BIOL8706_project/data/species_tree/exon_modelfinder.newick")
exon_mix <- read.tree("D:/BIOL8706_project/data/species_tree/exon_mix.newick")
inter_mf <- read.tree("D:/BIOL8706_project/data/species_tree/inter_mf.newick")
inter_mix <- read.tree("D:/BIOL8706_project/data/species_tree/inter_mix_rotate_new.newick")

# Replace underscores with spaces in tip labels
tree3$tip.label <- str_replace(tree3$tip.label, "_", " ")
exon_mix$tip.label <- str_replace(exon_mix$tip.label, "_", " ")
inter_mf$tip.label <- str_replace(inter_mf$tip.label, "_", " ")
inter_mix$tip.label <- str_replace(inter_mix$tip.label, "_", " ")

# Define colors for different clades
telluraves_color <- "darkgreen"
elementaves_color <- "#1F7A8C"
columbaves_color <- "#F3722C"
mirandornithes_color <- "#F94144"
galloanseres_color <- "#7D0D14"
other_color <- "black"  # Define the color for other branches as black

# Define species in each clade (tip label names)
telluraves_species <- c("Promerops cafer", "Cnemophilus loriae", "Menura novaehollandiae", 
                        "Serilophus lunatus", "Acanthisitta chloris", "Chunga burmeisteri", "Urocolius indicus")
elementaves_species <- c("Ciconia maguari", "Phaethon lepturus", "Nyctiprogne leucopyga", 
                         "Psophia crepitans", "Opisthocomus hoazin")
columbaves_species <- c("Crotophaga sulcirostris", "Lophotis ruficrista", "Tauraco erythrolophus", 
                        "Columbina picui", "Mesitornis unicolor")
mirandornithes_species <- c("Podiceps cristatus", "Podilymbus podiceps", "Phoenicopterus ruber")
galloanseres_species <- c("Callipepla squamata", "Chauna torquata", "Alectura lathami", "Gallus gallus")

# Create a vector with all species and their corresponding colors
label_colors <- c(
  setNames(rep(telluraves_color, length(telluraves_species)), telluraves_species),
  setNames(rep(elementaves_color, length(elementaves_species)), elementaves_species),
  setNames(rep(columbaves_color, length(columbaves_species)), columbaves_species),
  setNames(rep(mirandornithes_color, length(mirandornithes_species)), mirandornithes_species),
  setNames(rep(galloanseres_color, length(galloanseres_species)), galloanseres_species)
)
label_colors

# Plot Tree 1 (Exon ModelFinder)
p1 <- ggtree(tree3, aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic", align = TRUE, linesize = 1, offset = 1.25) +
  xlim(NA, 35) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Exon (ModelFinder)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  )

# Plot Tree 2 (Exon MixtureFinder)
p2 <- ggtree(exon_mix, aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic", align = TRUE, linesize = 1, offset = 1.25) +
  xlim(NA, 35) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Exon (MixtureFinder)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  )

# Plot Tree 3 (Intergenic ModelFinder)
p3 <- ggtree(inter_mf, aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic", align = TRUE, linesize = 1, offset = 1.25) +
  xlim(0, 35) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Intergenic (ModelFinder)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  )

# Plot Tree 4 (Intergenic MixtureFinder)
p4 <- ggtree(inter_mix, aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic", align = TRUE, linesize = 1, offset = 1.25) +
  xlim(NA, 35) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Intergenic (MixtureFinder)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  ) 

# Combine the plots
combined_plot <- grid.arrange(p1, p2, ncol = 1, nrow = 2)
combined_plot

# Save the plot to a file
# ggsave("D:/BIOL8706_project/data/4species_combined.png", plot = combined_plot, width = 4.67, height = 3.67, units = "in", dpi = 300)
