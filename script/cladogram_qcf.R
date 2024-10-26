library(ggtree)
library(gridExtra)
library(ape)
library(stringr)
library(treeio)

# Read tree files
exon_mf <- read.nexus("D:/BIOL8706_project/data/mass/qcf_main_treeplot/exon_mf1.nex")
exon_mix <- read.nexus("D:/BIOL8706_project/data/mass/qcf_main_treeplot/exon_mix.nex")
inter_mf <- read.nexus("D:/BIOL8706_project/data/mass/qcf_main_treeplot/inter_mf.nex")
inter_mix <- read.nexus("D:/BIOL8706_project/data/mass/qcf_main_treeplot/inter_mix.nex")

# Modify tip labels by replacing underscores with spaces
exon_mf$tip.label <- str_replace(exon_mf$tip.label, "_", " ")
exon_mix$tip.label <- str_replace(exon_mix$tip.label, "_", " ")
inter_mf$tip.label <- str_replace(inter_mf$tip.label, "_", " ")
inter_mix$tip.label <- str_replace(inter_mix$tip.label, "_", " ")

# Define colors for different clades
telluraves_color <- "darkgreen"
elementaves_color <- "#1F7A8C"
columbaves_color <- "#F3722C"
mirandornithes_color <- "#F94144"
galloanseres_color <- "#7D0D14"
other_color <- "black"  # Define color for other branches as black

# Define species in each clade (tip label names)
telluraves_species <- c("Promerops cafer", "Cnemophilus loriae", "Menura novaehollandiae", 
                        "Serilophus lunatus", "Acanthisitta chloris", "Chunga burmeisteri", "Urocolius indicus")
elementaves_species <- c("Ciconia maguari", "Phaethon lepturus", "Nyctiprogne leucopyga", 
                         "Psophia crepitans", "Opisthocomus hoazin")
columbaves_species <- c("Crotophaga sulcirostris", "Lophotis ruficrista", "Tauraco erythrolophus", 
                        "Columbina picui", "Mesitornis unicolor")
mirandornithes_species <- c("Podiceps cristatus", "Podilymbus podiceps", "Phoenicopterus ruber")
galloanseres_species <- c("Callipepla squamata", "Chauna torquata", "Alectura lathami", "Gallus gallus")

# Create a vector containing all species and their corresponding colors
label_colors <- c(
  setNames(rep(telluraves_color, length(telluraves_species)), telluraves_species),
  setNames(rep(elementaves_color, length(elementaves_species)), elementaves_species),
  setNames(rep(columbaves_color, length(columbaves_species)), columbaves_species),
  setNames(rep(mirandornithes_color, length(mirandornithes_species)), mirandornithes_species),
  setNames(rep(galloanseres_color, length(galloanseres_species)), galloanseres_species)
)

# Plot Tree 1: Exon MF (Cladogram)
p1 <- ggtree(exon_mf, branch.length = 'none', aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic",  linesize = 1) +
  xlim(NA, 18) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Exon (ModelFinder & Main tree fixed)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  )  +
  theme(axis.line.x = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.x = element_blank())

# Plot Tree 2: Exon Mix (MixtureFinder) - Cladogram
p2 <- ggtree(exon_mix, branch.length = 'none', aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic",  linesize = 1) +
  xlim(NA, 18) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Exon (MixtureFinder & Main tree fixed)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  ) +
  theme(axis.line.x = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.x = element_blank())

# Plot Tree 3: Inter MF (ModelFinder) - Cladogram
p3 <- ggtree(inter_mf, branch.length = 'none', aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic",  linesize = 1) +
  xlim(NA, 18) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Intergenic (ModelFinder & Main tree fixed)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  ) +
  theme(axis.line.x = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.x = element_blank())

# Plot Tree 4: Inter Mix (MixtureFinder) - Cladogram
p4 <- ggtree(inter_mix, branch.length = 'none', aes(color = label)) + 
  geom_tiplab(aes(label = label, color = label), size = 5, fontface = "italic",  linesize = 1) +
  xlim(NA, 18) +  # Set x-axis range
  theme_tree2() +
  labs(title = "Intergenic (MixtureFinder & Main tree fixed)") +
  geom_tree(aes(color = label), size = 2) +
  scale_color_manual(
    name = "Clade",
    values = label_colors, 
    na.value = other_color,
    breaks = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres"),
    labels = c("Telluraves", "Elementaves", "Columbaves", "Mirandornithes", "Galloanseres")
  ) +
  theme(axis.line.x = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.x = element_blank())

# Arrange the four plots together
grid.arrange(p1, p2, nrow = 2)
