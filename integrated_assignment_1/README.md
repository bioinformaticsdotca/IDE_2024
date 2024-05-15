---
layout: tutorial_page
permalink: /IDE_2024_int_assignment_1
title: IDE Integrated Assigment Number 1
header1: Workshop Pages for Students
header2: Integrated Assigment Number 1
image: /site_images/CBW_wshop-epidem_map-icon.png
home: https://bioinformaticsdotca.github.io/IDE_2024
description: IDE 2024 integrated assignment number 1
author: Venus Lau & Jimmy Liu

---

# IDE 2024 Integrated Assignment

## Developed by: Venus Lau & Jimmy Liu

### Introduction

In this integrative assignment, you will be applying some of the genomic epidemiology analysis methods covered in this workshop. The focus of the assignment will be on *Salmonella enterica*, an enteric pathogen that primarily spreads by human consumption of contaminated foods in Canada and the United States. Here, you will examine isolates of *Salmonella* serovar Heidelberg from three epidemiologically distinct foodborne outbreaks that occurred in Quebec, Canada between 2012-2014. For more detailed background on how the outbreaks happened, you are encouraged to read over the original publication by [Bekal et al. (2014)](https://pubmed.ncbi.nlm.nih.gov/26582830/). You will be analyzing the whole-genome sequencing (WGS) data generated from the study to investigate these foodborne outbreaks. Briefly, you will identify core genome single nucleotide variants (SNVs) from pre-assembled genomes, construct a core genome SNV phylogenetic tree and infer the evolutionary relationships of the isolates. In addition, you will annotate the bacterial genomes to detect the presence of various genetic features from this *Salmonella* outbreak dataset.

The primary goal here is to integrate evidence from the phylogeny and genome annotations to justify which isolates are most likely epidemiologically linked (belong to the same outbreak).

First, copy the assignment directory to your workspace on AWS:

```
cp -r ~/CourseData/IDE_data/integrated_assignment_1/ ~/workspace/
cd ~/workspace/integrated_assignment_1
```

You can find the following files if you run the command `ls ~/workspace/integrated_assignment_1`:

* Assembled *Salmonella* genomes
```
~/workspace/integrated_assignment_1/assemblies
```

* Reference sequence (Heidelberg str. SL476) for variant calling:
```
~/workspace/integraintegrated_assignment_1/reference
```

* Metadata file
```
~/workspace/integrated_assignment_1/metadata.csv
```

### Required tools
* [Snippy](https://github.com/tseemann/snippy)
* [FastTree](http://www.microbesonline.org/fasttree/)
* [ABRicate](https://github.com/tseemann/abricate)
* [R](https://www.r-project.org/)

___

### Core genome SNV analysis
To minimize the analysis runtime required, the SNV calling step using Snippy has already been done and you are provided a core genome SNV alignment to construct a phylogenetic tree in the next section. Additionally, you are provided a summary file that describes the number of SNVs identified and alignment statistics for each sample.

SNV and alignment summary is located at:
```
~/workspace/integrated_assignment_1/alignment/core_aln_stats.txt
```

Core genome alignment of the entire dataset is located at:
```
~/workspace/integrated_assignment_1/alignment/heidelberg_core.aln
```

Description of SNV alignment summary headers:

| Header | Description |
| --- | --- |
| ID | Sample identifier |
| LENGTH | Reference sequence length (bps) |
| ALIGNED | Reference sequence length aligned by query (bps) |
| UNALIGNED | Reference sequence length not aligned by query (bps) |
| VARIANT | Number of variants identified |
| HET | Number of heterozygous sites (mixed variants) |
| MASKED | Number of masked sites in reference sequence |
| LOWCOV | Number of aligned sites with low depth of coverage |

Review the summary file and the core genome alignment, and answer the following questions:

> ***Q1: What is the length of the alignment and how is this length determined?***

> ***Q2: Which isolate has the most detected variants relative to the reference genome? Which has the least?***

> ***Q3: Which statistics in the variant calling summary file might be useful for identifying outlier (poor quality) samples and why?***

___
### Phylogenetic analysis & visualization

Here, you are tasked with using `FastTree` to construct a maximum likelihood tree from the core genome SNV alignment. When visualizing the phylogenetic tree, make note of any clustering patterns and which strains are closely/distantly related.

To start, you will have to create your own environment with the needed tools (`FastTree`) and R packages (`r-tidyverse` and `r-ggpubr`). To do this you'll use the following conda create command and then activate the environment:
```bash
# Create command - 2 minutes
conda create -n integrated-assignment-1 -c conda-forge -c bioconda fasttree r-tidyverse r-ggpubr --yes
```

Hints:
1. Example `FastTree` usage: `FastTree -nt sequence.aln > tree.nwk`. You'll need to replace `sequence.aln` with the path to the correct alignment file
2. Use the `ggtree` R package to generate a visualization of the phylogenetic tree (using your provided RStudio instance: `xx.uhn-hpc.ca:8080`, where `xx` is your assigned student number)

  **Note:** `ggtree` **is unavailable in your Rstudio session when you load it. Run the following commands to install and load it:**
  ```r
  if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  # you can ignore if you get a warning message about the Bioconductor version
  
  BiocManager::install("ggtree")
  library(ggtree)
  
  ```
 Helpful starter code:
 ```r
 # make sure you are in the folder of the assignment
 
 #load files
 metadata<-read.csv("metadata.csv")
 tree<-read.tree("tree.nwk")
 ```
And fantastic tree documentation:
 1. [Visualizing phylogenetic trees](https://yulab-smu.top/treedata-book/chapter4.html#chapter4)
 2. [Adding metadata to your trees](https://yulab-smu.top/treedata-book/chapter7.html#attach-operator)
   
> ***Q4: What does the phylogenetic tree inform you about the relatedness of the isolates within the same outbreak and across different outbreaks?***

> ***Q5: Do the isolates cluster by isolation source (e.g. Human, Food) or isolation date?***

___
### Genome Annotation
Predicting genes and other functional elements (e.g. transcriptional elements, replication origins, mobile elements) can help explain the differences in biological, epidemiological, and ecological characteristics of microbial organisms. Genome annotations are also critical for risk assessments of infectious disease pathogens, as the detection of multiple antimicrobial resistance (AMR) or virulent genes are suggestive of high risks to public health or patient health that require immediate attention. 

Here, you will use a tool called `ABRicate` to search for the presence of plasmids, AMR genes and virulence factors (VF). You will need to search against three different nucleotide databases that contain reference sequences of curated elements. Once you have identified the genetic elements carried by the bacterial genomes, you will generate heatmaps to visualize the results and identify any correlations amongst within-outbreak strains and between-outbreak strains.

But first, you must install the `ABRicate` tool into your conda environment to be able to use it:
```bash
# Conda install - 1 minute
conda install -c bioconda abricate --yes
```

#### How to run `ABRicate`:
* Example ABRicate usage: `abricate --db db_name contigs.fa > report.tab`
* The main parameter, `--db` specifies which database you would like to search against. There are different databases for different genetic elements. You can find the list of pre-downloaded sequence databases by executing: `abricate --list`
* To search for AMR genes, virulence factors, and plasmids, the database names are `card`, `vfdb`, and `plasmidfinder`, respectively
* Once you have generated the required ABRicate outputs for all *Salmonella* genomes, combine the results of all genomes by executing: 
```bash
abricate --summary /path/to/amr_results_dir/*.tab > amr_summary.tab
```
#### How to visualize ABRicate summary results
* If you feel like challenging yourself with data visualization using R, then feel free to skip the instructions in this section and proceed to write your own codes in RStudio to plot the heatmaps.
* To help with results visualization, we have prepared a R script to generate heatmap plots directly from ABRicate summary results:
```bash
# Clone the IDE2021_integrated_hw GitHub repository to your current working directory
git clone https://github.com/jimmyliu1326/IDE2021_integrated_hw
# Inside the cloned repository, you will find a script called `abricate_heatmap.R`
# Example usage of the script
Rscript abricate_heatmap.R /path/to/amr_summary.tab /path/to/amr_heatmap.png
```

#### Hints:
1. You can only query one genome against one database at a time (How would you automate the search for multiple genomes?)
2. For each database (card, vfdb, plasmidfinder), organize the annotation results in a different directory 

> ***Q6: Can you infer which isolates are epidemiologically linked and which isolates are sporadic cases based on the presence/absence of the plasmids?***

> ***Q7: Do you see the same trend with AMR genes or virulence factors?***

> ***Q8: Looking at the AMR heatmap, which samples likely contain AMR genes encoded on plasmids and how would you verify this looking at ABRicate results?***

> ***Q9: Aside from plasmids, AMR genes and VF, can you think of other genetic features in bacterial genomes that may help discriminate between these outbreaks?***

