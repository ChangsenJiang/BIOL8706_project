# Project Outline


## 1. Overall aims of project 

A recent study [(Stiller *et al.* (2024))](https://www.nature.com/articles/s41586-024-07323-1) published in Nature reconstructed the phylogenetic history of avians using various locus types (different region). This study highlighted a strong effect of locus type on constructing gene trees and species trees, suggesting that intergenic regions yield more reliable results compared to exon regions, which produce substantially different tree outcomes. 

However, the original study used Modeltest-NG v0.1.3 and RAXML-NG v0.9.0 for evolution model estimation, potentially leading to a oversimplified evolutionary model for gene tree estimation. Furthermore, the original study used nucleotide sequence alignment for phylogenetic analysis in exon region, while the amino acid alignemnt would be more stable for phylogenetic analysis. These might unfairly attribute the poor performance of exon regions solely to locus type.  
As a consequence, in this study, we aim to use MixtureFinder [(Ren *et al.*, 2024)](https://www.biorxiv.org/content/10.1101/2024.03.20.586035v1.full#ref-14) to re-estimate the gene trees and species trees for both intergenic and exon regions to explore whether enhanced complex evolutionary models provide more accurate phylogenetic results.

In specific:

+ Whether the estimated species trees of intergenic regions would change when using mixture models 

+ Whether the estimated speices trees of exon regions would be more similar to the one estimated from intergenic regions when using mixture model


## 2. Dataset used

We will use the [dataset](https://erda.ku.dk/archives/341f72708302f1d0c461ad616e783b86/published-archive.html) from the avian evolution paper by [Stiller *et al.* (2024)](https://www.nature.com/articles/s41586-024-07323-1) 

Reason: This dataset is the original data of the avain evolution paper, and the procedure of this project is to re-estimate the GTs and species trees using mixture models. So of course I should use the same dataset as the original paper.
  

## 3. A brief description of the dataset(s)

The dataset contains a comprehensive range of data(size of alignment in this data set is 50 times larger than the most complex study before), including 
+ Alignments of **363 species across 218 families** (covering 92% of total bird families in **37 orders and 11 evolution clades**)
+ Tree files (1435 species trees in total)
+ Polytomy test results...

The alignemnt file contains alignment in different regions using different loci numbers, data have been cleaned and filtered by the author, and are descripted as table below (data from [Stiller *et al.* (2024)](https://www.nature.com/articles/s41586-024-07323-1) ):

| Data | Datatype | Description | Loci | Base pairs | 
|-------------|---------|--------|--------------------|-----------------|
| 94K| Intergenic regions      | All intergenic loci     | 94,402             | 94,402,000          |
| 80K| Intergenic regions      | Excluding overlap with exons     | 80,047             | 80,047,000          |
| 63K| Intergenic regions      | Exucluding overlap with exon or introns     | 63,430             | 63,430,000          |
| Intron| Introns      | All introns     | 44,846             | 136,940,000          |
| UCE| UCES      | Ultraconserved Element loci | 4985             | 25,259,810          |
| Exon| Exons      | All Exon loci | 14972             | 18,975,346          |



The data required for this project is 
+ Alignment file 
+ gene tree file 

for both the exon and intergenic regions, which have been cleaned and filtered by the author. detailed description of required data as below:

**Exon:**

+ 14972 Nucleotide Alignements of 14972 different exon locis (each of these alignments contain at least 4 taxa) in FASTA format.
+ 14972 Gene trees built from alignment above in newick format with support as aLRT values


**Intergenic region:**

+ Nucleotide Alignments of 63430 different loci from intergenic region in FASTA format for which gene trees were built

+ 63430 gene trees built from alignment above (after collapsing branches with aLRT values below 0.95). These trees were used to construct the species tree in original paper

## 4. A small subset of the data that you can test your code on 

### Subsetting loci:

I would randomly use 20 loci as the first small attempt. For further analysis, maybe I would use the first x% (maybe 20% of the loci?). I think I can’t use all, since 400 loci takes 3.5h in 128 threads, and 14972 and 63430 loci would take too long to finish. 

### Subset of species (if required?):

The original data contains 218 families and 363 species in 37 orders.

There are 6 "large Orders" containing more than 10 species (for example, Passeriformes has 173 species and Charadriiformes has 29 species), for those order less than 10 species, just retain all of these;
 
 For the species in 6 large orders, I might rank the occurance number of those species in selected loci, and select the top 10% species for each of these large orders (for example around 17 for passeriformes).


## 5. The plan for commands needed (e.g. IQ-TREE commands, ASTRAL commands)

**Subsetting orders:**

I would write a small python script (haven't done yet) to show the Order subsetting process, which creates a tabel file showing the occurance number of all species in 40 loci files, we could use R to further showing the result of first 10% species in the 6 “large orders”.


**Phylogenetic analysis process:**

### 1. Generate the tree in paper

**1.1 Estimate gene trees**


If not subsampling species, we could just subset the gene trees from the orginal data based on our selected loci.


If we subsample species, we should filter the selected loci alignment files with subeset species (probably need another python script), then use these alinments to estimating gene trees using the original model in paper through a command like this:

```
iqtree2 -S bird_subloci -m papermodel --prefix subloci -T 128
```

* `bird_subloci` is the name of directory containing alignment files of subsampled loci

> Question1: For this part, should we use the same model (by Modeltest-NG) in original paper?

> Question2: We might use `-st NT2AA` option to perform the estimation based on translated AA sequences. However, it don’t works so far since the exon nucleotide alignment contain gaps, which makes the number of sites is not multiple of 3.


**1.2 Estimate species trees**

Using the `subloci.tree` file produced above (file containg gene trees of our selected loci), using ASTRAL command like this:

```
astral -i subloci.treefile -o astral_species.tree 2> astral_species.log
```

The the number of loci subsetted would differ between intergeneic regions, but the process to estimate gene tree and species tree should be similar. 

> Question3: The original paper used ASTRAL to construce species tree which takes a treefile containing a set of gene trees to estimate. While the IQTree used the alignment file (and also the partition file) to estimate species tree. In this study maybe I should use ASTRAL all the time?

### 2. Re-estimating new trees using mixturefinder:

**2.1 Gene trees:**

First we use MixtureFinder to find the best model 

The -S option to specify a file directory with alignment files doesn’t work in MixtureFinder, so we need to **concatenate** the alignments among different loci into a single alignment file first:

```
iqtree2 -p bird_subloci --out -aln bird_conloci --out-format NEXUS
```

* `bird_subloci` is the name of directory containing alignment files of subsampled loci

Then Perform the MixtureFinder on concatenated alignments:

```
iqtree -s bird_conloci -m MIX+MF -T AUTO
```
Then use the new mixture model to calculate the gene trees
(here assume mixture model is `MIX{TIM2+FO,TPM3+FO,HKY+FO,TPM3+FO}+I+G`)

```
iqtree2 -S bird_subloci -m “MIX{TIM2+FO,TPM3+FO,HKY+FO,TPM3+FO}+I+G” --prefix mixsubloci -T 128
```

**2.2 Species trees:**

similar as above:
```
astral -i mixsubloci.treefile -o astral_mixspecies.tree 2> astral_mixspecies.log
```

### 3 Calculating several metrics

**3.1 ROBINSON-Foulds distance**

After calculating both(paper and MixtureFinder) species trees for both intergeneic and exon regions, we could calculate RF distances:

```
iqtree2 -rf astral_species astral_mixspecies
```
(we would also calculate the RF distance between Intergenic species trees from original paper and from using MixtureFinder)

**3.2 Concordance factor**

gCF: 

```
iqtree2 -te astral_mixspecies.treefile --gcf mixsubloci.treefile --prefix concord
```

qCF:

```
astral -q astral_mixspecies.treefile -i mixsubloci.treefile -t 2 -o astral_mixspecies_annotated.tree 2> astral_mixspecies_annotated.log
```

And also sCF...

```
# First approch
iqtree2 -te astral_mixspecies.treefile -s ALN_FILE --scfl 100 --prefix concord2

# Second approch to calculate gCF and sCF at the same time
iqtree2 -t astral_mixspecies.treefile --gcf mixsubloci.treefile -s ALN_FILE --scf 100
```

## 6. What I will measure and why

1: The bootstrap/UFBoot value to measure the statistical supports that our topology is supported by the data.

2: Compare the concordance factor between gene trees from the original paper and those new trees using MixtureFinder. 

[Concordance factor](https://ecoevorxiv.org/repository/view/6484/) is calculated as the proportion of gene trees/ or quartets/or deceive sites that have same topologies as the species tree. It is a measurement of the similarity between the gene tree and species tree. 

**If the concordance factor of new gene trees has greater value than that of the original paper. It indicates that the new model would improve the quality of gene tree estimation.**

3: Compare the Robinson-Foulds distance between the species trees of the exon and intergenic region. 

If the RF distance between the 2 species trees of different region (using MixtureFinder) is less than that RF distance between the 2 species trees of intergenic and exon region in original paper, it would indicates that our mixture model helps to construct better phylogenic result for the exon region. Furthermore, Robinson-Fould distance could also used to check whether the intergenic species tree changed. 
>Question 4: If I subsampled the loci (or species), that means the RF distance in original paper and the Rf distance in this project would based on different data amount, is this acceptable?