library(ggtree)
library(gridExtra)
library(ape)
library(ggplot2)

# Reading the tree files
exon_mf <- read.tree("D:/BIOL8706_project/data/4255exon_modelfinder_result/4255mf_combined.treefile")
exon_mix <- read.tree("D:/BIOL8706_project/data/4255exon_mix_result_new/4255combined_newmix.treefile")
inter_mf <- read.tree("D:/BIOL8706_project/data/mass/36794inter_mf_result/36794inter_mf_result/mf_combined.treefile")
inter_mix <- read.tree("D:/BIOL8706_project/data/mass/36794inter_mix_result/36794_mix_combined.treefile")

# Calculating total branch lengths for each tree
exon_mf_tree_lengths <- sapply(exon_mf, function(tree) sum(tree$edge.length))
exon_mix_tree_lengths <- sapply(exon_mix, function(tree) sum(tree$edge.length))
inter_mf_tree_lengths <- sapply(inter_mf, function(tree) sum(tree$edge.length))
inter_mix_tree_lengths <- sapply(inter_mix, function(tree) sum(tree$edge.length))

# Calculating the ratio of MixtureFinder to ModelFinder tree lengths
exon_ratio <- exon_mix_tree_lengths / exon_mf_tree_lengths
inter_ratio <- inter_mix_tree_lengths / inter_mf_tree_lengths

# Creating a data frame for visualization
tree_lengths_df <- data.frame(
  tree_length = c(exon_mf_tree_lengths, exon_mix_tree_lengths, 
                  inter_mf_tree_lengths, inter_mix_tree_lengths),
  group = c(rep("ModelFinder", length(exon_mf_tree_lengths)), 
            rep("MixtureFinder", length(exon_mix_tree_lengths)),
            rep("ModelFinder", length(inter_mf_tree_lengths)), 
            rep("MixtureFinder", length(inter_mix_tree_lengths))),
  region = c(rep("Exon", length(exon_mf_tree_lengths) + length(exon_mix_tree_lengths)),
             rep("Intergenic Region", length(inter_mf_tree_lengths) + length(inter_mix_tree_lengths)))
)

# Plotting the boxplot, faceted by region
ggplot(tree_lengths_df, aes(x = group, y = tree_length, fill = group)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~ region, scales = "free_y") +
  labs(y = "Gene Tree Length") +
  scale_x_discrete(limits = c("ModelFinder", "MixtureFinder")) +  # Adjust the order
  theme_minimal() +
  theme(strip.text.y = element_text(size = 11, face = "bold", colour = "black"),
        strip.text = element_text(size = 11, face = "bold"),
        axis.text = element_text(size = 11, face = "bold"),  # Labels for x and y axes
        axis.title = element_text(size = 13, face = "bold")) +  # Titles for x and y axes
  scale_fill_manual(values = c("ModelFinder" = "darkgrey", "MixtureFinder" = "darkgreen")) +
  xlab(NULL)  # Remove x-axis label
