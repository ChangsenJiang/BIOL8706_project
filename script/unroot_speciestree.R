library(ape)

exon_mix <- read.tree(file = "D:/BIOL8706_project/data/species_tree/4255species_mix_fullname.tree")
str(exon_mix)
exon_mf <- read.tree(file = "D:/BIOL8706_project/data/species_tree/4255species_mf_fullname.tree")
inter_mix <- read.tree(file = "D:/BIOL8706_project/data/species_tree/astral_36794_mix_species.tree")
inter_mf <- read.tree(file = "D:/BIOL8706_project/data/species_tree/astral_36794_mf_species.tree")

unrooted_tree1 <- unroot(exon_mix)
unrooted_tree2 <- unroot(exon_mf )
unrooted_tree3 <- unroot(inter_mix)
unrooted_tree4 <- unroot(inter_mf)

write.tree(unrooted_tree1, file = "D:/BIOL8706_project/data/species_tree/4255species_mix_unrooted.tree")
write.tree(unrooted_tree2, file = "D:/BIOL8706_project/data/species_tree/4255species_mf_unrooted.tree")
write.tree(unrooted_tree3, file = "D:/BIOL8706_project/data/species_tree/36794species_mix_unrooted.tree")
write.tree(unrooted_tree4, file = "D:/BIOL8706_project/data/species_tree/36794species_mf_unrooted.tree")
