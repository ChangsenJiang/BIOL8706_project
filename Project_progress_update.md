# Bird-tree Progress updata

Similar to the initial update, but a new readme file, covering the full datasets your are using, the commands you are using to do your analyses, and outlining how you plan to assess the results (e.g. plots, etc.) If you can provide example results from your initial small analyses, that will be very very useful!

## 1. Full datasets

Based on 
- gene coverage (the number of genes that contain that species) (using `select_gene_species.py` in script folder)
- select 2 species at either side of the deepest split for each clade
- the rest of the selected species are closest to the crown node of each clade

**24 species** ( 7 for Telluraves, 5 for Elementaves, 5 for Columbaves, 3 for Mirandornithes, 4 for Galloanseres ) were selected.

After that, **4255 exon loci** containing all of these 24 species were filtered using the `filterespecies_new.py` script in script folder. Each of the 4255 filtered alignment files would only contain the 24 species instead of 363, and those files are placed in `4255species_exondata_filtered` folder.

The analysis below was based on these 4255 exon loci. For the **full dataset**, I would change the filter logic to "include any loci that contain two or more of these 24 species", which would result in many more loci.


## 2. Analysis Process (Exon)

Up to now, I have analysised exon loci 

### Model finder

For the ModelFinder, the following command was used (in server) to calculate gene trees.

```
iqtree2 -S 4255exon -m MFP -pre /data/changsen/4255exon_modelfinder_result/4255mf_combined -T 75
```

It produces a `4255mf_combined.treefile` treefile, which contains 4255 gene trees.

Then I used ASTRAL (in my laptop) to generate the species tree

```
astral -i 4255mf_combined.treefile -o astral_4255species_mf.tree 2> astral_4255species_mf.log
```
It produces a species tree file called `astral_4255species_mf.treefile`.

After that, I calculated the **quartet concordance factor (qCF) and the posterial probability (pp)** using

```
astral -i 4255mf_combined.treefile -q astral_4255species_mf.tree -t 2 -o astral_4255species_mf_qcf.tree  2> astral_4255species_mf_qcf.log
```
It produces a `astral_4255species_mf_qcf.tree` treefile, in which the qCF (q1,q2,q3) and the posterial probability (pp1) were listed in the annotation (`[]`).

After filtering out other information using a python script, we finally produce a `4255_mf_qcf_pp_annotated.tree` file.



### MixtureFinder 

First, I run the `write_multiple_linuxcmd.R` script to write 4255 command into a text file (`iqtree_commands.txt` in the script folder), one single line of that command is:

```
/data/changsen/bin/iqtree2 -s /data/changsen/4255exon/GALGAL_R00006.fa.nt_ali.filtered.fasta -m MIX+MF -T 1 -mset GTR -pre /data/changsen/4255exon_result/R00006
```
Then, I used the bash script `run_cmd_parallel_new.sh` to run the 4255 command parallelly in server (maximum CPU was set to 75)

After that, MixTurefinder would produce 4255 gene trees, and `combine_genetree.R` was used to combine them into a single tree file.

Then I used ASTRAL (in my laptop) to generate the species tree

```
astral -i 4255combined.treefile -o astral_4255species_mix.tree 2> astral_4255species_mix.log
```
It produces a species tree file called `astral_4255species_mix.treefile`

Then for the qCF and posterial probability (pp)

```
astral -i 4255combined.treefile -q astral_4255species_mix.tree -t 2 -o astral_4255species_mix_qcf.tree  2> astral_4255species_mix_qcf.log
```
It produces a `astral_4255species_mix_qcf.tree` treefile, further cleaned up to `4255_qcfpp_annotated.tree`


### ROBINSON-Foulds distance

The ROBINSON-Foulds distance between the species trees calculated by MixtureFinder and ModelFinder was calculated by:


```
iqtree2 -rf astral_4255species_mix.tree astral_4255species_mf.tree
``` 

$$
\text{Standardized RF Distance} = \frac{\text{Original RF Distance}}{\text{Maximum RF Distance}}
$$

Where:

- **Original RF Distance** is the value obtained from the `iqtree2 -rf` command.
- **Maximum RF Distance** is calculated as:

$$
\text{Maximum RF Distance} = 2 \times (n - 3)
$$

Here, \( n \) is the number of species in the tree.


The analysis of the Intergenic region will be performed after finishing exon... 


## 3 Exon results and Outline for Result Assessment

The assessment for the result, as well as the example result of the 4255 exon were shown below:

### 3.1: The species tree with qCF and pp annotated:

The species tree of 4255 loci using ModelFinder, annoated with qCF and pp value：
![Modelfinder Image](data/modelfinder_annotated.jpg)

The species tree of 4255 loci using ModelFinder, annoated with qCF and pp value：
![Mixturefinder Image](data/mixturefinder_annotated.jpg)


> [!NOTE]
> Problem1: Even when using 4255 exon loci (approximately 30% of overall exon loci), both ModelFinder and MixtureFinder could not correctly recover the main clades.<br> Problem2: **The qCF of MixtureFinder is sometimes lower than the qCF in ModelFinder**, this is unexpected, maybe there are some problems in the species tree generating or the qCF generating process, but I haven't figure out why

### 3.2: Table showing the qCF and pp for each Clade in each method 

Since the Elementaves and Columbaves could not be recovered in both plots above, here I **only show the 3 clades that is recovered or basically recovered** (the 3 red circles in the tree above):

| Clade | qCF_MF | qCF_Mix | pp_MF | pp_Mix | 
|-------------|---------|--------|--------------------|-----------------|
| Telluraves | 0.41      | 0.399     | 1.0             | 1.0          |
| Mirandornithes | 0.62      | 0.604     | 1.0             | 1.0          |
| Galloanseres | 0.753  | 0.742    | 1.0            | 1.0        |

From the table above, we see that in **nodes spliting 3 main clades, qCF of MF are always larger than qCF of Mixture Finder** 

### 3.3: Boxplot & density plot to show the distribution of qCF between different method

![boxplot](data/box_density.png)

From the plot above, we could see in large qCF value range (qCF > 0.9), qCFs of ModelFinder are usually larger than thoses of MixtureFinder. However, in most of the lower qCF value range, qCFs of MixtureFinder are usually larger than thoses of ModelFinder.


### 3.4: ROBINSON-Foulds distance (species vs species, gene trees vs species)

The ROBINSON-Foulds distance between the 2 species trees of MixtureFinder and ModelFinder is calculated based on the formula above, and the result is 8/42 = **0.1905**.

After finishing the intergenic region analysis, I would also calculate **the RF distance between the exon and intergenic species trees in 2 different method (MF and MixureFinder)**, the RF distance using MixtureFinder is expected be less than that calculated using ModelFinder.

Furthermore, I also calculate the RF distance between the **gene trees and the species tree** produced by those gene trees:

```
iqtree2 -rf astral_4255species_mix.tree 4255combined.treefile
```

```
iqtree2 -rf astral_4255species_mf.tree 4255mf_combined.treefile
```

The result could be visualized for different method (MF and MixureFinder). The RF distance using MixtureFinder is expected be less than that calculated using ModelFinder.


> [!NOTE]
> Problem3: However, my results so far seems to be strange: all gene trees have the same original RF distance (92) to the species tree in both MixtureFinder and ModelFinder...


## 4 Future Plan

- Solve quesition 1 to 3 above
- Perform the analysis for Intergenic region
- Try to also calculate sCF and gCF, and generate the concordance table and clade plot similar to that one in the concordance paper

```

```


