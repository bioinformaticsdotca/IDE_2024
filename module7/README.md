---
layout: tutorial_page
permalink: /IDE_2024_Module7_lab
title: CBW Infectious Disease Epidemiology 2024
header1: Workshop Pages for Students
header2: CBW Infectious Disease Epidemiology 2024 Module 7 Lab
image: /site_images/CBW_epidemiology_icon.png
home: https://bioinformaticsdotca.github.io/
description: CBW IDE 2024 Module 7 - Antimicrobial Resistant Gene (AMR) Analysis
author: Andrew McArthur, Madeline McCarthy, and Karyn Mukiri
modified: May 6, 2024
---

## Table of contents
0. [Download Files](#download)
1. [Introduction](#intro)
2. [CARD Website and Antibiotic Resistance Ontology](#cardweb)
3. [RGI for Genome Analysis](#rgigenome)
4. [RGI at the Command Line](#rgicommand)
5. [RGI for Merged Metagenomic Reads](#rgimerged)
6. [Metagenomic Sequencing Reads and the KMA Algorithm](#bwt)

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

RGI is a command line tool as well, so we’ll do an analysis of 39 *E. coli* genome assemblies from [Whole-Genome Characterization and Strain Comparison of VT2f-Producing Escherichia coli Causing Hemolytic Uremic Syndrome](https://wwwnc.cdc.gov/eid/article/22/12/16-0017-f2). We’ll additionally try RGI’s heat map tool to compare genomes.

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

We don’t have time to analyze all 39 samples, so let’s analyze 1 as an example (the course GitHub repo contains an EXCEL version of the resulting [ED010.txt](https://github.com/bioinformaticsdotca/IDE_2024/blob/main/module7/rgi_main_results/ED010.xlsx) file). When analyzing FASTA files we use the **main** sub-command, here with default settings “**Perfect and Strict hits only**”, "**Exclude nudge**", and "**High quality/coverage**":

```bash
rgi main -h
rgi main -i /home/ubuntu/CourseData/IDE_data/module7/ecoli/ED010.fasta -o ED010 -t contig -a DIAMOND -n 4 --local --clean
ls
less ED010.json
less ED010.txt
column -t -s $'\t' ED010.txt  | less -S
```

<details>
  <summary>Discussion Points:</summary>

Default RGI **main** analysis of ED010 lists 12 Perfect annotations and 39 Strict annotations. Yet, 43 annotations are efflux components common in *E. coli* that may or may not lead to clinical levels of AMR. Nonetheless, outside of efflux there are some antibiotic inactivation and target alteration genes, but only EC beta-lactamase is notable. This isolate is primarily resistant to fluoroquinolone, aminocoumarin, macrolide, and tetracycline antibiotics, although the acrD gene can also contribute resistance to aminoglycosides.
                
</details>

What if these results did not explain our observed phenotype? We might want to explore the RGI Loose hits (the course GitHub repo contains an EXCEL version of the resulting [ED010_IncludeLoose.txt](https://github.com/bioinformaticsdotca/IDE_2024/blob/main/module7/rgi_main_results/ED010_IncludeLoose.xlsx) file), shown here with settings “**Perfect, Strict, and Loose hits**”, "**Include nudge**", and "**High quality/coverage**":

```bash
rgi main -h
rgi main -i /home/ubuntu/CourseData/IDE_data/module7/ecoli/ED010.fasta -o ED010_IncludeLoose -t contig -a DIAMOND -n 4 --local --clean --include_nudge --include_loose
ls
column -t -s $'\t' ED010_IncludeLoose.txt  | less -S
```

<details>
  <summary>Discussion Points:</summary>

An additional 11 nudged Strict annotations (possible partial genes for *Escherichia coli* emrE, EF-Tu mutants conferring resistance to Pulvomycin, and AcrF) and 394 Loose annotations have been added to investigate for leads that could explain the observed phenotype. Note this scenario is unlikely for clinical isolates given CARD's reference data, but is possible for environmental isolates. The multiple putative gene fragments found via the Nudge may suggest genome assembly problems.
                
</details>

We have pre-compiled results for all 39 samples under “**Perfect and Strict hits only**"", "**Exclude nudge**", and "**High quality/coverage**", so let’s try RGI’s heat map tool ([pre-compiled images](https://github.com/bioinformaticsdotca/IDE_2024/tree/main/module7/rgi_main_results) can be downloaded or viewed from the course GitHub repo):

```bash
ls /home/ubuntu/CourseData/IDE_data/module7/ecoli_json
rgi heatmap -h
rgi heatmap -i /home/ubuntu/CourseData/IDE_data/module7/ecoli_json -o heatmap
rgi heatmap -i /home/ubuntu/CourseData/IDE_data/module7/ecoli_json -o cluster_both --cluster both
rgi heatmap -i /home/ubuntu/CourseData/IDE_data/module7/ecoli_json -o cluster_both_frequency --frequency --cluster both
ls
```

> Yellow represents a Perfect hit, teal represents a Strict hit, purple represents no hit.

<details>
  <summary>Discussion Points:</summary>

The last analysis is the most informative, showing that many of these isolates share the same complement of efflux variants (bottom of heatmap) and several isolates share the same overall resistome. Yet most isolates are unique in their resistome, with a subset sharing TEM-1, sul1, and other higher risk genes. Placing these results in phylogenetic and epidemiological context will be helpful.

</details>

<a name="microreact"></a>
### Integration with Microreact

You can use the following annotation file to visualize all of the RGI results in the context of [Microreact](https://microreact.org) visualizations: [RGI microreact results plus earlier derived whole genome SNP tree](https://github.com/bioinformaticsdotca/IDE_2024/tree/main/module7/for_microreact).

Notes on the metadata:
* We include RGI Perfect and Strict annotations, but ignore Loose annotations
* We are ignoring all efflux results
* We are ignoring the one vancomycin resistance gene annotated as it was a false positive (i.e. not all of the genes in van clusters found)
* We did not run RGI on the reference genome

**Do you think there is evidence of lateral gene transfer?**

<a name="rgimerged"></a>
## RGI for Merged Metagenomic Reads

The standard RGI tool can be used to analyze metagenomics read data, but only for assembled or merged reads with Prodigal calling of partial open reading frames (ORFs). Here we will demonstrate analysis of merged reads. This is a computationally expensive approach, since each merged read set may contain a partial ORF, requiring RGI to perform massive amounts of BLAST/DIAMOND analyses. While computationally intensive (and thus generally not recommended), this does allow analysis of metagenomic sequences in protein space, including key substitutions, overcoming issues of high-stringency read mapping relative to nucleotide reference databases.

Lanza et al. ([Microbiome 2018, 15:11](https://www.ncbi.nlm.nih.gov/pubmed/29335005)) used AMR gene bait capture to sample human gut microbiomes for AMR genes. Using the [online RGI](https://card.mcmaster.ca/analyze/rgi) under “**Perfect, Strict and Loose hits**”, "**Include nudge**", and "**Low quality/coverage**" settings, analyze the first 500 merged metagenomic reads from their analysis (file [`ResCap_first_500.fasta`](https://github.com/bioinformaticsdotca/IDE_2024/blob/main/module7/sequences_for_web_demo/ResCap_first_500.fasta)). Take a close look at the predicted “sul” genes in the results table. How good is the evidence for these AMR genes in this enriched metagenomics sample?

<details>
  <summary>Discussion Points:</summary>

There is no evidence of a sul1 gene, but there are three merged reads with 100% identity to ~25% of the sul2 gene each. In constrast, there are three merged reads with low identity to sul3, suggesting spurious annotations, with very similar results for sul4 (9 merged reads with less than 50% identity to the reference sul4 protein).
                
</details>

<a name="bwt"></a>
## Metagenomic Sequencing Reads and the KMA Algorithm

The most common tools for metagenomic data annotation are based on high-stringency read mapping, such as the [KMA read aligner](https://bitbucket.org/genomicepidemiology/kma/src/master) due to its [documented better performance for redundant databases such as CARD](https://github.com/arpcard/rgi/blob/master/docs/rgi_bwt.rst). Available methods almost exclusively focus on acquired resistance genes (e.g., sequences referenced in CARD's protein homolog models), not those involving resistance via mutation. However, CARD and other AMR reference databases utilize reference sequences from the published literature with clear experimental evidence of elevated minimum inhibitory concentration (MIC). This has implications for molecular surveillance as sequences in agricultural or environmental samples may differ in sequence from characterized & curated reference sequences, which are predominantly from clinical isolates, creating false negative results for metagenomic reads for these environments. As such, CARD's tools for read mapping can use either canonical CARD (reference sequences from the literature) or predicted AMR resistance alleles and sequence variants from bulk resistome analyses, i.e. [CARD Resistomes & Variants data set](https://card.mcmaster.ca/resistomes).

To demonstrate read mapping using RGI **bwt**, we will analyze a ~160k paired read subset of the raw sequencing reads from Lanza et al.'s ([Microbiome 2018, 15:11](https://www.ncbi.nlm.nih.gov/pubmed/29335005)) use of AMR gene bait capture to sample human gut microbiomes.

First we need to acquire the additional AMR reference data from the previous CARD website download:

```bash
rgi card_annotation -i ./card.json > card_annotation.log 2>&1
rgi load --card_json ./card.json --card_annotation card_database_v3.2.6.fasta --local
ls
```

Let's take a look at the raw gut metagenomics data to remind ourselves of the FASTQ format:

```bash
ls /home/ubuntu/CourseData/IDE_data/module7/gut_sample
less /home/ubuntu/CourseData/IDE_data/module7/gut_sample/gut_R1.fastq
```

We can now map the metagenomic reads to the sequences in CARD's protein homolog models using the KMA algorithm:

```bash
rgi bwt -1 /home/ubuntu/CourseData/IDE_data/module7/gut_sample/gut_R1.fastq -2 /home/ubuntu/CourseData/IDE_data/module7/gut_sample/gut_R2.fastq -a kma -n 4 -o gut_sample.kma --local
ls
```

RGI **bwt** produces a LOT of output files, see the details at the [RGI GitHub repo](https://github.com/arpcard/rgi/blob/master/docs/rgi_bwt.rst). First, let's look at the summary statistics:

```bash
cat gut_sample.kma.overall_mapping_stats.txt
ls
```

However, the file we are most interested in for now is [`gut_sample.kma.gene_mapping_data.txt`](https://github.com/bioinformaticsdotca/IDE_2024/blob/main/module7/rgi_bwt_results/gut_sample.kma.gene_mapping_data.xlsx) and the course GitHub repo contains an EXCEL version for easy viewing, but let's look at it on the command line:

```bash
column -t -s $'\t' gut_sample.kma.gene_mapping_data.txt  | less -S
cut -f 1 gut_sample.kma.gene_mapping_data.txt | sort -u | wc -l
ls
```

* Ignoring efflux, which AMR gene had the most mapped reads?
* Ignoring efflux, which AMR gene had the highest % coverage?
* How many AMR genes were found in total?
* From these results and what you know about assembly, what do you think are the advantages/disadvantages of read-based methods?

<details>
  <summary>Answers:</summary>

Top 5 (non-efflux) for number of mapped reads:
* tet(Q) with 40345 reads
* tet(X) with 7205 reads
* ErmF with 6510 reads
* CblA-1 with 4160 reads
* tet(O) with 1608 reads

Top 5 (non-efflux) for % length coverage (all had 100%):
* tet(Q)
* tet(X)
* ErmF
* CblA-1
* tet(O)

90 AMR genes had sequencing reads mapped.

Read-based analyses advantages and disadvantages:
* Higher sensitivity (we find as many AMR genes as possible)
* Lower specificity (we are more likely to make mistakes when identifying AMR genes)
* Incomplete data (we are likely to find fragments of genes instead of whole genes, this can lead to confusion between similar genes)
* No genomic context (we don't know where a gene we detect comes from in the genome, is it associated with a plasmid?)

</details>

We can repeat the read mapping analysis, but include more sequence variants in the reference set by including the [CARD Resistomes & Variants data set](https://card.mcmaster.ca/resistomes). First we need to acquire the Resistomes & Variant data from the CARD website:

> THE FOLLOWING STEPS TAKE TOO LONG, DO NOT PERFORM DURING DEMO SESSION, INSTEAD PLEASE VIEW PRE-COMPILED RESULTS. FEEL FREE TO TRY THESE STEPS OUTSIDE OF CLASS.

```bash
wget -O wildcard_data.tar.bz2 https://card.mcmaster.ca/latest/variants
mkdir -p wildcard
tar -xjf wildcard_data.tar.bz2 -C wildcard
gunzip wildcard/*.gz
rgi wildcard_annotation -i wildcard --card_json ./card.json -v 4.0.0 > wildcard_annotation.log 2>&1
rgi load --card_json ./card.json --wildcard_annotation wildcard_database_v4.0.0.fasta --wildcard_index ./wildcard/index-for-model-sequences.txt --card_annotation card_database_v3.2.6.fasta --local
```

Map reads to canonical CARD (reference sequences from the literature) **plus** predicted AMR resistance alleles and sequence variants from bulk resistome analyses, i.e. [CARD Resistomes & Variants data set](https://card.mcmaster.ca/resistomes):

> THE FOLLOWING STEPS TAKE TOO LONG, DO NOT PERFORM DURING DEMO SESSION, INSTEAD PLEASE VIEW PRE-COMPILED RESULTS. FEEL FREE TO TRY THESE STEPS OUTSIDE OF CLASS.

```bash
rgi bwt -1 /home/ubuntu/CourseData/IDE_data/module7/gut_sample/gut_R1.fastq -2 /home/ubuntu/CourseData/IDE_data/module7/gut_sample/gut_R2.fastq -a kma -n 4 -o gut_sample_wildcard.kma --local --include_wildcard
ls
```

The pre-compiled results can be viewed in the EXCEL version of [`gut_sample_wildcard.kma.gene_mapping_data.txt`](https://github.com/bioinformaticsdotca/IDE_2024/blob/main/module7/rgi_bwt_results/gut_sample_wildcard.kma.gene_mapping_data.xlsx) in the GitLab repo, but let's first compare statistics, where you'll see we aligned some additional reads:

> YOU CAN EXECUTE THESE COMMANDS AS WE HAVE PROVIDED PRE-COMPUTED RESULTS.

```bash
clear
cat /home/ubuntu/CourseData/IDE_data/module7/kmaresults/gut_sample.kma.overall_mapping_stats.txt
cat /home/ubuntu/CourseData/IDE_data/module7/kmaresults/gut_sample_wildcard.kma.overall_mapping_stats.txt
cut -f 1 /home/ubuntu/CourseData/IDE_data/module7/kmaresults/gut_sample_wildcard.kma.gene_mapping_data.txt | sort -u | wc -l
ls
```

Looking at the pre-compiled EXCEL spreadsheet, note that we have more information based on [CARD Resistomes & Variants data set](https://card.mcmaster.ca/resistomes), such as mappings to multiple alleles, flags for association with plasmids, and taxonomic distribution of the mapped alleles.

* Ignoring efflux, which AMR gene had the most mapped reads?
* How many AMR genes were found in total?
* Which genes associated with plasmids have the most mapped reads?

<details>
  <summary>Answers:</summary>

Top 5 (non-efflux) for number of mapped reads gives the same list but with more data:
* tet(Q) with 42684 mapped reads (up from 40345 reads)
* tet(X) with 7393 mapped reads (up from 7205 reads)
* ErmF with 6987 mapped reads (up from 6510 reads)
* CblA-1 with 4160 mapped reads (no change)
* tet(O) with 1870 mapped reads (up from 1608 reads)

114 AMR genes had sequencing reads mapped (up from 90).

Top 5 (plasmid associated) for number of mapped reads:
* tet(X) with 7393 reads
* acrD with 1881 Reads
* APH(6)-Id with 1418 reads
* sul2 with 961 reads
* aad(6) with 99 reads

</details>
