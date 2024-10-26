library(tidyverse)
library(ggtree)
library(ape)
library(gridExtra)
library(dendextend)

# Reading your tree files (.tree files)
tree3 <- read.tree("D:/BIOL8706_project/data/species_tree/exon_modelfinder.newick")
exon_mix <- read.tree("D:/BIOL8706_project/data/species_tree/exon_mix.newick")
inter_mf <- read.tree("D:/BIOL8706_project/data/species_tree/inter_mf.newick")
inter_mix <- read.tree("D:/BIOL8706_project/data/species_tree/inter_mix.newick")

# Replace underscores in tip labels with spaces for better readability
tree3$tip.label <- str_replace(tree3$tip.label, "_", " ")
exon_mix$tip.label <- str_replace(exon_mix$tip.label, "_", " ")
inter_mf$tip.label <- str_replace(inter_mf$tip.label, "_", " ")
inter_mix$tip.label <- str_replace(inter_mix$tip.label, "_", " ")

# Read the original trees for comparison
original_inter <- read.tree("D:/BIOL8706_project/data/species_tree/maintree_reroot.newick")
original_exon <- read.tree("D:/BIOL8706_project/data/species_tree/original_exon_reroot.newick")

# Replace underscores in original tree tip labels with spaces
original_inter$tip.label <- str_replace(original_inter$tip.label, "_", " ")
original_exon$tip.label <- str_replace(original_exon$tip.label, "_", " ")

# Define colors for each clade
telluraves_color <- "darkgreen"
elementaves_color <- "#1F7A8C"
columbaves_color <- "#F3722C"
mirandornithes_color <- "#F94144"
galloanseres_color <- "#7D0D14"
other_color <- "black"  # Define color for other clades as black

# Define species in each clade (tip label names)
telluraves_species <- c("Promerops cafer", "Cnemophilus loriae", "Menura novaehollandiae", 
                        "Serilophus lunatus", "Acanthisitta chloris", "Chunga burmeisteri", "Urocolius indicus")
elementaves_species <- c("Ciconia maguari", "Phaethon lepturus", "Nyctiprogne leucopyga", 
                         "Psophia crepitans", "Opisthocomus hoazin")
columbaves_species <- c("Crotophaga sulcirostris", "Lophotis ruficrista", "Tauraco erythrolophus", 
                        "Columbina picui", "Mesitornis unicolor")
mirandornithes_species <- c("Podiceps cristatus", "Podilymbus podiceps", "Phoenicopterus ruber")
galloanseres_species <- c("Callipepla squamata", "Chauna torquata", "Alectura lathami", "Gallus gallus")

# Create a vector of species and their corresponding colors
label_colors <- c(
  setNames(rep(telluraves_color, length(telluraves_species)), telluraves_species),
  setNames(rep(elementaves_color, length(elementaves_species)), elementaves_species),
  setNames(rep(columbaves_color, length(columbaves_species)), columbaves_species),
  setNames(rep(mirandornithes_color, length(mirandornithes_species)), mirandornithes_species),
  setNames(rep(galloanseres_color, length(galloanseres_species)), galloanseres_species)
)

# Plot Tree 1 (Exon ModelFinder)
p1 <- ggtree(inter_mf, branch.length = 'none', aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic", linesize = 1, offset = 1.25) +
  xlim(NA, 30) +  # Set x-axis limits
  theme_tree2() +
  labs(title = "Intergenic (Single model)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  )

# Plot Tree 2 (Intergenic Mixture Model)
p2 <- ggtree(inter_mix, branch.length = 'none', aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic", 
              linesize = 1, offset = -1.25, hjust = 1) +  # Adjust alignment
  theme_tree2() +
  labs(title = "Intergenic (Mixture model)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  ) +
  scale_x_reverse(limits = c(30, 0))  # Reverse x-axis and set limits from 30 to 0

# Arrange the two plots side by side
grid.arrange(p1, p2, ncol = 2, nrow = 1)
