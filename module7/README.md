---
layout: tutorial_page
permalink: /IDE_2024_Module6_lab
title: CBW Infectious Disease Epidemiology 2024
header1: Workshop Pages for Students
header2: CBW Infectious Disease Epidemiology 2024 Module 6 Lab
image: /site_images/CBW_epidemiology_icon.png
home: https://bioinformaticsdotca.github.io/
description: CBW IDE 2024 Module 6 - Antimicrobial Resistant Gene (AMR) Analysis
author: Andrew McArthur, Madeline McCarthy, and Karyn Mukiri
modified: May 1, 2024
---

## Table of contents
0. [Download Files](#download)
1. [Introduction](#intro)
2. [CARD Website and Antibiotic Resistance Ontology](#cardweb)
3. [RGI for Genome Analysis](#rgigenome)
4. [RGI at the Command Line](#rgicommand)
5. [Microreact Files](#microreact)

<a name="download"></a>
## Download Files

If you are doing this demo live, you can download all the files we will be viewing here: https://github.com/bioinformaticsdotca/IDE_2024/tree/main/module7/downloads_for_demo

<a name="intro"></a>
## Introduction

This module gives an introduction to prediction of antimicrobial resistome and phenotype based on comparison of genomic or metagenomic DNA sequencing data to reference sequence information. While there is a large diversity of reference databases and software, this tutorial is focused on the Comprehensive Antibiotic Resistance Database ([CARD](http://card.mcmaster.ca)) for genomic AMR prediction.

There are several databases (see [here](https://www.nature.com/articles/s41576-019-0108-4/tables/2) for a list) which try and organise information about AMR as well as helping with interpretation of resistome results.
Many of these are either specialised on a specific type of resistance gene (e.g., [beta-lactamases](http://bldb.eu/)), organism (e.g., [_Mycobacterium tuberculosis_](https://github.com/jodyphelan/tbdb)), or are an automated amalgamation of other databases (e.g., [MEGARes](https://megares.meglab.org/)). 
There are also many tools for detecting AMR genes each with their own strengths and weaknesses (see [this paper](https://www.frontiersin.org/articles/10.3389/fpubh.2019.00242/full) for a non-comprehensive list of tools!).

The "Big 3" databases that are comprehensive (involving many organisms, genes, and types of resistance), regularly updated, have their own gene identification tool(s), and are carefully maintained and curated are: 

1. Comprehensive Antibiotic Resistance Database ([CARD](https://card.mcmaster.ca)) with the Resistance Gene Identifier ([RGI](https://github.com/arpcard/rgi)).
2. National Center for Biotechnology Information's National Database of Antibiotic Resistant Organisms ([NDARO](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/)) with [AMRFinderPlus](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/).
3. [ResFinder](http://genepi.food.dtu.dk/resfinder) database with its associated [ResFinder](https://bitbucket.org/genomicepidemiology/resfinder/src/master/) tool.

In this practical we are going to focus on CARD and the associated RGI tool because:
* The [Antibiotic Resistance Ontology](https://card.mcmaster.ca/ontology/36006) it is built upon is a great way to organize information about AMR.
* CARD is the most heavily used database internationally, with over 6000 citations.
* We are biased. CARD is Canadian and pretty much all the CBW faculty collaborate or are part of the group that develops CARD! See [Alcock *et al.* 2023. CARD 2023: expanded curation, support for machine learning, and resistome prediction at the Comprehensive Antibiotic Resistance Database. *Nucleic Acids Research*, 51, D690-D699](https://pubmed.ncbi.nlm.nih.gov/36263822/).

<a name="cardweb"></a>
## CARD Website and Antibiotic Resistance Ontology

The relationship between AMR genotype and AMR phenotype is complicated and no tools for complete prediction of phenotype from genotype exist. Instead, analyses focus on prediction or catalog of the AMR resistome - the collection of AMR genes and mutants in the sequenced sample. While BLAST and other sequence similarity tools can be used to catalog the resistance determinants in a sample via comparison to a reference sequence database, interpretation and phenotypic prediction are often the largest challenge. To start the tutorial, we will use the Comprehensive Antibiotic Resistance Database ([CARD](http://card.mcmaster.ca)) website to examine the diversity of resistance mechanisms, how they influence bioinformatics analysis approaches, and how CARD’s [Antibiotic Resistance Ontology](https://card.mcmaster.ca/ontology/36006) (ARO) can provide an organizing principle for interpretation of bioinformatics results.

CARD’s website provides the ability to: 

* Browse the [Antibiotic Resistance Ontology](https://card.mcmaster.ca/ontology/36006) (ARO) and associated knowledgebase.
* Browse the underlying AMR detection models, reference sequences, and SNP matrices.
* Download the ARO, reference sequence data, and indices in a number of formats for custom analyses.
* Perform integrated genome analysis using the Resistance Gene Identifier (RGI).

In this part of the tutorial, your instructor will walk you through the following use of the CARD website to familiarize yourself with its resources:

1. What are the mechanisms of resistance described in the Antibiotic Resistance Ontology?
2. Examine the NDM-1 beta-lactamase protein, it’s mechanism of action, conferred antibiotic resistance, it’s prevalence, and it’s detection model. 
3. Examine the AAC(6')-Iaa aminoglycoside acetyltransferase, it’s mechanism of action, conferred antibiotic resistance, it’s prevalence, and it’s detection model. 
4. Examine the fluoroquinolone resistant gyrB for *M. tuberculosis*, it’s mechanism of action, conferred antibiotic resistance, and it’s detection model. 
5. Examine the MexAB-OprM efflux complex with MexR mutations, it’s mechanism of action, conferred antibiotic resistance, it’s prevalence, and it’s detection model(s). 

<details>
  <summary>Answers:</summary>
    
1. 
	+ antibiotic target alteration
	+ antibiotic target replacement
	+ antibiotic target protection
	+ antibiotic inactivation
	+ antibiotic efflux
	+ reduced permeability to antibiotic
	+ resistance by absence
	+ modification to cell morphology
	+ resistance by host-dependent nutrient acquisition
	+ antibiotic target overexpression   
2. NDM-1: antibiotic inactivation; beta-lactams (penam, cephamycin, carbapenem, cephalosporin); over 50 pathogens (lots of ESKAPE pathogens) - note strong association with plasmids; protein homolog model
3. AAC(6')-Iaa: antibiotic inactivation; aminogylcosides; _Salmonella enterica_; protein homolog model
4. gyrB: antibiotic target alteration; fluoroquinolones; _Mycobacterium_; protein variant model
5. MexAB-OprM with MexR mutations: antibiotic efflux; broad range of drug classes; looking at MexA sub-unit: _Pseudomonas_; efflux meta-model
                
</details>
 
<a name="#rgigenome"></a>
## RGI for Genome Analysis

As illustrated by the exercise above, the diversity of antimicrobial resistance mechanisms requires a diversity of detection algorithms and a diversity of detection limits. CARD’s Resistance Gene Identifier (RGI) currently integrates four CARD detection models: [Protein Homolog Model, Protein Variant Model, rRNA Variant Model, and Protein Overexpression Model](https://github.com/arpcard/rgi/blob/master/docs/rgi_main.rst). Unlike naïve analyses, CARD detection models use curated cut-offs, currently based on BLAST/DIAMOND bitscore cut-offs. Many other available tools are based on BLASTN or BLASTP without defined cut-offs and avoid resistance by mutation entirely. 

In this part of the tutorial, your instructor will walk you through the following use of CARD’s [Resistome Gene Identifier](https://card.mcmaster.ca/analyze/rgi) with default settings “Perfect and Strict hits only”, "Exclude nudge", and "High quality/coverage":

* Resistome prediction for the multidrug resistant *Acinetobacter baumannii* MDR-TJ, complete genome (NC_017847).
* Resistome prediction for the plasmid isolated from *Escherichia coli* strain MRSN388634 plasmid (KX276657).
* Explain the difference in fluoroquinolone resistance MIC between two clinical strains of *Pseudomonas aeruginosa* that appear clonal based on identical MLST ([`Pseudomonas1.fasta`, `Pseudomonas2.fasta`](https://github.com/bioinformaticsdotca/IDE_2024/tree/main/module7/sequences_for_web_demo) - these files can be found in this GitHub repo). Hint, look at SNPs.

<details>
  <summary>Answers:</summary>

The first two examples list the predicted resistome of the analyzed genome and plasmid, while the third example illustrates that `Pseudomonas2.fasta` contains an extra T83I mutation in gyrA conferring resistance to fluoroquinolones, above that provided by background efflux.
                
</details>
 
<a name="rgicommand"></a>
## RGI at the Command Line

RGI is a command line tool as well, so we’ll do an analysis of 39 *E. coli* genome assemblies from infections in the Hamilton, Ontario region. We’ll additionally try RGI’s heat map tool to compare genomes.

Login into your course account’s working directory and make a module7 directory:

```bash
cd ~/workspace
mkdir module7
cd module7
```

Take a peak at the list of *E. coli* samples:

```bash
ls /home/ubuntu/CourseData/IDE_data/module7/ecoli
```

RGI has already been installed using Conda, list all the available software in Conda, activate RGI, and then review the RGI help screen:

```bash
conda env list
conda activate rgi
rgi -h
```

First we need to acquire the latest AMR reference data from the CARD website:

```bash
rgi load -h
wget https://card.mcmaster.ca/latest/data
tar -xvf data ./card.json
less card.json
rgi load --card_json ./card.json --local
ls
```

We don’t have time to analyze all 39 samples, so let’s analyze 1 as an example (the course GitHub repo contains an EXCEL version of the resulting [ED010.txt](https://github.com/agmcarthur/vtec2023-amr/tree/main/rgi_main_results/ED010.xlsx) file). When analyzing FASTA files we use the **main** sub-command, here with default settings “**Perfect and Strict hits only**”, "**Exclude nudge**", and "**High quality/coverage**":

```bash
rgi main -h
rgi main -i /home/ubuntu/workspace/CourseData/IDE_data/module7/ecoli/ED010.fasta -o ED010 -t contig -a DIAMOND -n 4 --local --clean
ls
less ED010.json
less ED010.txt
column -t -s $'\t' ED010.txt  | less -S
```

<details>
  <summary>Discussion Points:</summary>

Default RGI **main** analysis of ED010 lists 12 Perfect annotations and 39 Strict annotations. Yet, 43 annotations are efflux components common in *E. coli* that may or may not lead to clinical levels of AMR. Nonetheless, outside of efflux there are some antibiotic inactivation and target alteration genes, but only EC beta-lactamase is notable. This isolate is primarily resistant to fluoroquinolone, aminocoumarin, macrolide, and tetracycline antibiotics, although the acrD gene can also contribute resistance to aminoglycosides.
                
</details>

What if these results did not explain our observed phenotype? We might want to explore the RGI Loose hits (the course GitHub repo contains an EXCEL version of the resulting [ED010_IncludeLoose.txt](https://github.com/agmcarthur/vtec2023-amr/tree/main/rgi_main_results/ED010_IncludeLoose.xlsx) file), shown here with settings “**Perfect, Strict, and Loose hits**”, "**Include nudge**", and "**High quality/coverage**":

```bash
rgi main -h
rgi main -i /home/ubuntu/workspace/CourseData/IDE_data/module7/ecoli/ED010.fasta -o ED010_IncludeLoose -t contig -a DIAMOND -n 4 --local --clean --include_nudge --include_loose
ls
column -t -s $'\t' ED010_IncludeLoose.txt  | less -S
```

<details>
  <summary>Discussion Points:</summary>

An additional 11 nudged Strict annotations (possible partial genes for *Escherichia coli* emrE, EF-Tu mutants conferring resistance to Pulvomycin, and AcrF) and 394 Loose annotations have been added to investigate for leads that could explain the observed phenotype. Note this scenario is unlikely for clinical isolates given CARD's reference data, but is possible for environmental isolates. The multiple putative gene fragments found via the Nudge may suggest genome assembly problems.
                
</details>

We have pre-compiled results for all 39 samples under “**Perfect and Strict hits only**"", "**Exclude nudge**", and "**High quality/coverage**", so let’s try RGI’s heat map tool ([pre-compiled images](https://github.com/agmcarthur/vtec2023-amr/tree/main/rgi_main_results) can be downloaded or viewed from the course GitHub repo):

```bash
ls /home/ubuntu/workspace/CourseData/IDE_data/module7/ecoli_json
rgi heatmap -h
rgi heatmap -i /home/ubuntu/workspace/CourseData/IDE_data/module7/ecoli_json -o heatmap
rgi heatmap -i /home/ubuntu/workspace/CourseData/IDE_data/module7/ecoli_json -o cluster_both --cluster both
rgi heatmap -i /home/ubuntu/workspace/CourseData/IDE_data/module7/ecoli_json -o cluster_both_frequency --frequency --cluster both
ls
```

> Yellow represents a Perfect hit, teal represents a Strict hit, purple represents no hit.

<details>
  <summary>Discussion Points:</summary>

The last analysis is the most informative, showing that many of these isolates share the same complement of efflux variants (bottom of heatmap) and several isolates share the same overall resistome. Yet most isolates are unique in their resistome, with a subset sharing TEM-1, sul1, and other higher risk genes. Placing these results in phylogenetic and epidemiological context will be helpful.

</details>

<a name="microreact"></a>
## Microreact Files

You can use the following annotation file to visualize all of the RGI results in the context of [Microreact](https://microreact.org) visualizations: [RGI microreact results plus earlier derived whole genome SNP tree](https://github.com/agmcarthur/vtec2023-amr/tree/main/for_microreact).

Notes on the metadata:
* We include RGI Perfect and Strict annotations, but ignore Loose annotations
* We are ignoring all efflux results
* We are ignoring the one vancomycin resistance gene annotated as it was a false positive (i.e. not all of the genes in van clusters found)
* We did not run RGI on the reference genome

**Do you think there is evidence of lateral gene transfer?**
