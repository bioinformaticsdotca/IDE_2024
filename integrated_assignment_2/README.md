---
layout: tutorial_page
permalink: /IDE_2024_int_assignment_2
title: IDE Integrated Assigment Number 2
header1: IDE Integrated Assigment Number 2
header2: Genomic Epidemiological Analysis of SARS-CoV-2 Omicron Emergence
image: /site_images/CBW_wshop-epidem_map-icon.png
home: https://bioinformaticsdotca.github.io/IDE_2024
description: IDE 2024 integrated assignment number 2
author: Darian Hole, Katherine Eaton, Gary Van Domselaar
modified: May 09, 2024

---

# Table of contents
1. [Introduction](#intro)
2. [Software](#software)    
3. [Setup](#setup)
4. [Assignment](#assignment)
   1. [Phylogenetic Construction](#phylogenetic-construction)
   2. [Phylogenetic Visualization and Analysis Questions](#phylodynamic-analysis)
   3. [Nextclade Analysis](#nextclade-analysis)
   4. [Recombination Analysis](#recombination-analysis)

<a name="intro"></a>
# 1. Introduction 

In late 2021, South Africa experienced a resurgence in SARS-CoV-2 cases that was accompanied by an increase of Spike-gene diagnostic  assay PCR failures. This specific diagnostic characteristic was associated with the earlier Alpha Variant of Concern (VOC) and not of the currently circulating Delta VOC. Due to this, a targeted sequencing effort was initiated to investigate this unusual variant. A new, genetically distinct lineage was quickly identified. Cases linked to this lineage rapidly increased in both South Africa and subsequently worldwide with it being designated as a new WHO VOC called Omicron in under 10 days from the initial sequencing result. You are interested in performing a genomic epidemiological investigation of the source, evolutionary relationship, and genetic characteristics of this newly emergent lineage. To do this, you have randomly sampled a small subset of the global diversity of SARS-CoV-2 lineages hosted on [GISAID](https://gisaid.org/) from the onset of the pandemic until early 2022 supplemented with a subset of the first reported Omicron sequences from both South Africa and Canada.

Important terms on variant typing of the SARS-CoV-2 virus:
* Pango Lineage / Lineage: Variant type called using the [Pangolin](https://cov-lineages.org/index.html#about) tool which provides a finely-detailed nomenclature on the input genome based on all of the currently designated lineages.
* Nextstrain Clade / Clade: Variant typing called using the [Nextstrain](https://nextstrain.org/) naming guidelines/tools. These clades are a bit more relaxed than the Pangolin lineages with the aim to new clades created by significant differences in biological impact or circulation patterns.
* WHO Variants of Concern: Variants designated by the WHO and given an easy to say greek alphabet label

This integrated assignment will focus on the genomic epidemiological analysis of the emergence of the SARS-CoV-2 VOC Omicron using tools and methods covered in the other modules of the course. Once finished the assignment, check out the published paper on the epidemiological investigation of early Omicron from South Africa:

> Viana, R., Moyo, S., Amoako, D.G. et al. Rapid epidemic expansion of the SARS-CoV-2 Omicron variant in southern Africa. Nature 603, 679–686 (2022). https://doi.org/10.1038/s41586-022-04411-y

<a name="software"></a>
# 2. List of Software Utilized

* [Augur](https://docs.nextstrain.org/projects/augur/en/stable/index.html)
  * [mafft](https://mafft.cbrc.jp/alignment/software/)
  * [iqtree](http://www.iqtree.org/)
  * [timetree](https://treetime.readthedocs.io/en/latest/)
* [Auspice](https://auspice.us/)
* [Nextclade](https://clades.nextstrain.org/)
* [Rebar](https://github.com/phac-nml/rebar)

The workshop machines already have this software installed within a conda environment called `integrated-assignment-2`

<a name="setup"></a>
# 3. Assignment Setup

## 3.1. Copy data files

To begin, we will copy over the assignment files to `~/workspace`.

**Commands**
```bash
cp -r ~/CourseData/IDE_data/integrated_assignment_2/data/ ~/workspace/integrated_assignment_2
cd ~/workspace/integrated_assignment_2
```

This will copy over the 3 files that you need to do the assignment, which you can check with `ls` and should give:
```
metadata.tsv  selected_sequences.fasta  sequences.fasta
```

## 3.2. Activate environment

Activate the conda environment `integrated-assignment-2` which has all of the tools used in this assignment.

## 3.3. Verify your workshop machine URL

This exercise will produce output files intended to be viewed in a web browser. These should be accessible by going to <http://xx.uhn-hpc.ca> in your web browser where **xx** is your particular number (like 01, 02, etc.).

<a name="assignment"></a>
# 4. Assignment

<a name="phylogenetic-construction"></a>
## 4.1. Phylogenetic construction:

As seen previously in Module 8, we are going to construct a phylogenetic tree using the `Augur` tool suite, this time with a set of global SARS-CoV-2 sequences and their associated metadata subsampled from GISAID. Revisit that module to refamiliarize yourself with the commands if needed! You can also run `COMMAND --help` to gain more information on the parameters associated with each of the tools used. The structure of this section has all of the full commands hidden by default so you can practice constructing your own commands. It will take around 10 minutes total for the commands to execute.

*Tip*: When running through the assignment, remember to keep track of what you name your output files as each step builds off of the previously generated output files. If you are figuring out your own commands and comparing them to the full given commands there will likely be differences in these parameter inputs!

*Note*: There are some potential differences that can occur in the final tree topology due to the random seeding of the initial parsimony trees and the small number of iterations run (not running any bootstrapping). To enforce a common tree topology, we are going to use a fixed seed of `100` when building the trees.

### Step 1. Construct a multiple sequence alignment

Using `augur align` and the `--reference-name Wuhan-Hu-1/2019` reference sequence that is found in the given `sequences.fasta` file, construct a multiple sequence alignment using four threads.

<details>
<summary>Command and Parameters</summary>

Command:  
<pre>
<code># 1. Align with Augur using mafft - 2 min
augur align \
  --nthreads 4 \
  --sequences sequences.fasta \
  --reference-name 'Wuhan-Hu-1/2019' \
  --output aligned.fasta
</code>
</pre>

Parameters:
<pre>
<code>--nthreads 4: Use 4 threads for the alignment
--sequences sequences.fasta: Input set of sequences including the reference in fasta format
--reference-name 'Wuhan-Hu-1/2019': The reference Wuhan-1 genome identifier found in our sequences file to remove insertions relative to
--output aligned.fasta: Output alignment file in fasta format  
</code>
</pre>
</details>


### Step 2. Build a maximum likelihood phylogenetic tree

Next, using `augur tree` and your newly generated multiple sequence alignment with `--alignment`, construct a maximum likelihood tree. Include the `--tree-builder-args "-seed 100"` parameter in your command to keep all assignment trees matching, and remember that output trees should be formatted in the newick format with the `.nwk` extension. Use four threads.

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 2. Build Maximum Likelihood Phylogenetic Tree with Augur using iqtree2 - 40 sec
augur tree \
  --nthreads 4 \
  --alignment aligned.fasta \
  --tree-builder-args "-seed 100" \
  --output tree.nwk
</code>
</pre>

Parameters:
<pre>
<code>--nthreads 4: Use 4 threads for building the ML tree
--alignment aligned.fasta`: Input multiple sequence alignment file from the previous step
--tree-builder-args "-seed 100": Seed given to iqtree to keep all output tree topology the same
--output tree.nwk: Output phylogenetic tree in newick format
</code>
</pre>
</details>


### Step 3. Infer time tree

The next step is to infer a time tree using the `augur refine --timetree` command along with your multiple sequence alignment (`--alignment`), provided metadata, and newly generated maximum likelihood `--tree` newick file. 

Tip: This is a long command; remember to add in the following parameters:
* Root your tree with the Wuhan 1 reference `--root 'Wuhan-Hu-1/2019'`
* Set your divergence units for visualizing later on `--divergence-units mutations`
* Set both of your output files `--output-tree timetree.nwk` and `--output-node-data branch_lengths.json`
* Add in the `--seed 100` parameter

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 3. Build time tree with Augur using timetree - 4 min
augur refine \
  --timetree \
  --tree tree.nwk \
  --alignment aligned.fasta \
  --metadata metadata.tsv \
  --root 'Wuhan-Hu-1/2019' \
  --divergence-units mutations \
  --output-tree timetree.nwk \
  --output-node-data branch_lengths.json \
  --seed 100
</code>
</pre>

Parameters:
<pre>
<code>--timetree: Specify that augur refine should build a time tree
--tree tree.nwk: Input newick tree build using iqtree
--alignment aligned.fasta: Input multiple sequence alignment from augur align
--metadata metadata.tsv: Input metadata file containing the sequence names (column: `strain`) and collection dates (column: `date`)
--root 'Wuhan-Hu-1/2019': Keep the Wuhan-1 reference genome as the root of the tree
--divergence-units mutations: Convert the branch lengths to mutations for visualizing later on
--output-tree timetree.nwk: Output time tree newick file
--output-node-data branch_lengths.json: Output file to write branch lengths as node data
--seed 100: Seed given to be used instead to keep tree topologies the same
</code>
</pre>
</details>


### Step 4. Infer ancestral states for lineages/clades

Next, we are going to infer ancestral traits for the different typing schemes found in the `metadata.tsv` file. To do this, use the `augur traits` command along with the newly created `timetree` and the desired columns from the metadata file. The output should be set with `--output-node-data`.

The `--columns` to use are:
- `clade_who`: The WHO designated clade (or blank if the sample is not in a WHO clade)
- `clade_nextstrain`: The clade designated by Nextstrain
- `pangolin_lineage`: The lineage assigned by the Pangolin lineage assignment pipeline

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 4. Infer ancestral node traits for given columns - 20 seconds
augur traits \
  --tree timetree.nwk \
  --metadata metadata.tsv \
  --columns clade_who pangolin_lineage clade_nextstrain \
  --output-node-data node_traits.json
</code>
</pre>

Parameters:
<pre>
<code>--tree timetree.nwk: Input time tree created with augur refine
--metadata metadata.tsv: Input metadata file with the information we have to infer ancestral states with
--columns clade_who pangolin_lineage clade_nextstrain: The columns in the metadata file to use for inference 
--output-node-data node_traits.json: Output file to write trait inferences to
</code>
</pre>
</details>


### Step 5. Export for visualization 

Finally, export your visualization as an Auspice JSON file using `augur export v2`. The  export command below should work if you have been using the names in the commands provided for you; otherwise, you may have to adjust the input file names for the `--tree` and `--node-data` arguments.

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 5. Export tree to auspice json file - 20 sec
augur export v2 \
  --tree timetree.nwk \
  --node-data branch_lengths.json node_traits.json \
  --maintainers "CBW-IDE-2024" \
  --title "Integrated Assignment 2" \
  --output auspice.json
</code>
</pre>

Parameters:
<pre>
<code>--tree timetree.nwk: Input time tree created with augur refine
--node-data branch_lengths.json node_traits.json: Input node data json files created in step 3 (branch length) and step 4 (traits)
--maintainers "CBW-IDE-2024": Maintainer name to be displayed by auspice. Can be whatever you like
--title "Integrated Assignment 2": Title to be displayed by auspice. Can be whatever you would like
--output auspice.json: Output JSON file to be used in auspice for visualization and tree exploration
</code>
</pre>
</details>

<a name="phylodynamic-analysis"></a>
## 4.2. Phylogenetic visualization and analysis questions

Visualize the tree using auspice to help answer the following questions.

### Step 1: Load data into Auspice

Download the ouput Auspice JSON file and the `metadata.tsv` file by right-clicking `Save link as...`. 

Go to https://auspice.us/ and drag and drop in the saved JSON file and the `metadata.tsv` file to visualize your created phylogenetic tree with metadata. Spend a bit exploring the tree and seeing where all of the clades are along with how the branch lengths compare when visualized by both `Time` and `Divergence`

### Step 2: Answer the following questions using the visualization and prompts

Looking at the time phylogeny, find both Omicron and Delta on the tree (hint: Colour by "clade_who"). Noting that Omicron emerged when the Delta lineages were prevalent globally, from the phylogeny:
> ***Q1: What can you infer about the relationship between the Delta and Omicron variants?***

> ***Q2: What is the lineage of the most recent common ancestor (MRCA) of both Delta and Omicron? (hint: Remember lineage is from Pangolin. Colour the tree by "pangolin_lineage")***

Next, zoom in on the Omicron clade. 
> ***Q3: Based on your tree, where and when was the first Omicron case identified? Is there enough evidence in our tree to say this is where Omicron emerged? (hint: Label tips by country, click on the nodes, explore around)***

The emergence of Omicron was characterized by three distinct lineages that were all detected at roughly the same time in the order of: `BA.1`, `BA.2`, and then `BA.3`.

> ***Q4: When was the MRCA of all 3 of the Omicron lineages (BA.1, BA.2, and BA.3) predicted to be? What about BA.2 and BA.3?***

> ***Q5: What does this tell you about the diversification of the Omicron VOC prior to its detection in the population?***

Zooming back out, the Omicron clade has an unusually long branch length back to its most recent common ancestor suggesting a period of unsampled diversification of before its emergence.
> ***Q6: Which lineage does Omicron appear to have diverged from?***

> ***Q7: How long a period of unsampled diversity do you estimate for the Omicron VOC based on the inferred dates?***

> ***Q8: Based on all of the previous answers, what hypotheses for the emergence of Omicron are consistent with your observations? Is there anything about the country of origin that suggests one hypothesis over another?***

Now, set the branch length from `Time` to `Divergence`and view the tree in a `Radial` layout. Colour by `who_clade`.
> ***Q9: Do any of the other WHO VOCs (alpha, beta, gamma, delta) show a similar phylogenetic emergence structure to that of Omicron? What, if anything, can you conclude about the emergence of VOCs?***

<a name="nextclade-analysis"></a>
## 4.3 Nextclade analysis

You are looking to explore the different molecular profiles of the VOCs by analysing and visualizing them using [nextclade](https://clades.nextstrain.org/) and comparing them to Omicron. Nextclade is a tool that performs genetic sequence alignment, clade assignment, mutation calling, phylogenetic placement, and quality checks for different viral pathogens. It can be run either on the command line or locally in your browser (no data leaves your computer!) Remember to keep your auspice tree open to assist in analyzing the VOCs.

The WHO VOCs are:
* Alpha
* Beta
* Gamma
* Delta
* Omicron

### Step 1. 

Download the `selected_sequences.fasta` file to your computer and then load it into nextclade by dragging it into your browser. Then set the dataset to the official `SARS-CoV-2` dataset and click run.

### Step 2. Using nextclade, answer the following questions

Nextclade will show the distribution of mutations along either specific genes or over the whole genome with the default view being set to show mutations in the Spike protein.

> ***Q10: The [TaqPath three-gene RT-PCR assay for SARS-CoV-2](https://www.thermofisher.com/ca/en/home/clinical/clinical-genomics/pathogen-detection-solutions/covid-19-sars-cov-2/multiplex.html) experienced diagnostic failures for Alpha due to the 69-70del mutation in one of the assay primers. This assay failed in the same target in some of the the initial Omicron lineages. Based on the nextclade visualization, which lineage(s) contain this mutation?***

Change the view from the default of spike to the ‘Nucleotide sequence’ option to view the full distribution of mutations across the genome

> ***Q:11 Can you find any other mutations in Omicron that are common to the other VOCs? Given the phylogenetic relationship of the VOCs, can you provide a hypothesis for your observation of common mutations between them?***

> ***Q12: In which gene(s) are the mutations of the VOCs concentrated? Why is this the case?***

<a name="recombination-analysis"></a>
## 4.4 Recombination analysis

With both of the Delta and Omicron VOCs circulating in the population at the same time in December 2021, there was ample opprotunity for co-infections to occur with a high probability of recombination events happening. This lead to the first "deltacron" recombinat being identified in France in January 2022. Recombinant SARS-CoV-2 sequences consist of genomic elements from two different lineages/variants with one or more breakpoints in which the recombination occured.

To identify potential recombinants and breakpoints, we are going to use the tool `rebar` that follows the [PHA4GE Guidance for Detecting and Characterizing SARS-CoV-2 Recombinants](https://github.com/pha4ge/pipeline-resources/blob/main/docs/sc2-recombinants.md) for detecting and visualizing SARS-CoV-2 recombination.

### Step 1. Download

First, we have to download a version controlled SARS-CoV-2 dataset for rebar to be able to detect breakpoints and recombinants. For more information on what is contained in a dataset, checkout the [rebar dataset page](https://github.com/phac-nml/rebar/blob/main/docs/dataset.md). As a quick introduction though, the dataset directory consists minimally of:
1. The Wuhan-1 reference genome
2. Population fasta file with known clades/lineages aligned to the reference

To download the required dataset to be able to detect recombinants, you will have to use the `rebar dataset download` command. This command requires an input dataset name (`--name sars-cov-2`), an input date tag, which we will use `--tag 2023-11-30` for, and an `--output-dir` to save the dataset to. Remember, you can almost always run `TOOL --help` to get more info on how to run a tool.

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 1. Download dataset to run rebar - 10 sec
rebar dataset download \
  --name sars-cov-2 \
  --tag 2023-11-30 \
  --output-dir dataset/2023-11-30
</code>
</pre>

Parameters:
<pre>
<code>--name sars-cov-2: Input dataset name to grab
--tag 2023-11-30: Input date tag for the dataset
--output-dir dataset/2023-11-30: Output directory name to save the dataset to
</code>
</pre>
</details>

### Step 2. Run

Next, run the `rebar run` command using the newly created `--dataset-dir` and your initial aligned fasta file (`--alignment`) to begin the process of detecting any potential recombinant genomes in our input sequences. Output data again should be saved to a specified `--output-dir`.

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 2. Run rebar detection - 2 minutes
rebar run \
  --dataset-dir dataset/2023-11-30 \
  --alignment aligned.fasta \
  --output-dir rebar_recombination
</code>
</pre>

Parameters:
<pre>
<code>--dataset-dir dataset/2023-11-30: Input SARS-CoV-2 dataset downloaded in the prior step
--alignment aligned.fasta: Input aligned fasta file all the way back from augur align
--output-dir rebar_recombination: Output directory for rebar to save to
</code>
</pre>
</details>

### Step 3. Plot

Finally, run `rebar plot` to create visualizations of the potential recombinants detected using the previous output `--run-dir` and the `--annotations` file found in your downloaded rebar dataset from step 1 (hint: This file is called `annotations.tsv`).

<details>
<summary>Command and Parameters</summary>

Command:
<pre>
<code># 3. Plot rebar detections - 5 sec
rebar plot \
  --run-dir rebar_recombination \
  --annotations dataset/2023-11-30/annotations.tsv
</code>
</pre>

Parameters:
<pre>
<code>--run-dir rebar_recombination: Input directory containing rebar run results to be used for plotting
--annotations dataset/2023-11-30/annotations.tsv: Input annotations file containing a table of genome annotations to add to the plot
</code>
</pre>
</details>

### Questions

Now view the PNG images produced by Rebar (found in `rebar_recombination/plots`) and answer the following questions for the `XB`, `XD`, and `XF` recombinants detected:
> ***Q13: What lineages comprise the recombinant?***

> ***Q14: In which genes do recombination break points occur?***

With the knowledge of which samples were detected as recombinants along with which lineages make up their recombination, look back at the time tree and find the detected recombinant samples (hint: Colour by `who_clade`).
> ***Q:15 Where do the the XD and XF recombinant samples place on the phylogeny? Are they located where you'd expect based on their components? Would you expect their placement to be accurate?***
