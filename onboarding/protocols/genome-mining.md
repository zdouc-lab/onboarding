# Genome mining onboarding information

<img src="https://github.com/zdouc-lab/.github/raw/main/profile/zdouc_logo_v1.svg" style="width: 25vw"/>

*Nota bene: this is a living document and will change with time. Make sure to return regularly.*

## Table of contents

*Nota bene: this installation guide assumes that you are working on a Linux-like system and have basic knowledge how to operate the command line.*

This document gives an introduction to common genome mining tools and concepts. 
This document is structured as follows:

- [Introduction](#introduction)
- [Important tools and how to install them]()
- [How to get genomes]()

## Introduction

Genome sequencing creates huge amounts of information that cannot be interpreted manually. 
Therefore, researchers have developed software tools to help parsing, annotating, and interpreting data.

Broadly, these tools can be categorized into:

- Rule-based tools (built upon rules drawn from scientific observations; reliable but biased towards existing literature)
- Machine learning-based tools (trained on labeled or unlabeled data; less reliable but more permissive towards non-canonical findings)

This protocol/tutorial focuses on established, rule-based tools, which are good for "everyday use"

## Important tools and how to install them

### antiSMASH

The most commonly used genome mining tool.
AntiSMASH uses a set of pre-established rules to determine the "core regions" of biosynthetic gene clusters (BGCs).
Additional tools and comparison against databases such as MIBiG and MITE allow annotation of BGCs.

For single jobs, antiSMASH's web instance can be conveniently used. 
To run multiple files at once, see the local installing and running instructions below.

#### Installation

*Nota bene: assumes that `.local/bin` is in `$PATH`*

```commandline
curl -q https://dl.secondarymetabolites.org/releases/latest/docker-run_antismash-full > ~/.local/bin/run_antismash
chmod a+x ~/.local/bin/run_antismash
```

#### Running the tool

To run the tool, provide an input file and an output directory.
The command below contains all options to run a "full" analysis

```commandline
run_antismash GCA_026625765.1.gbk antismash/ -c 4 -v -t bacteria --fullhmmer --clusterhmmer --genefunctions-mite-version latest \ 
--tigrfam --asf --cc-mibig --cb-general --cb-subclusters --cb-knownclusters --pfam2go --rre --smcog-trees
```

antiSMASH can also be run on multiple files in parallel (adjust the number of cocurrent jobs and cores per job on availability of computer)

```commandline
parallel -j JOBS 'run_antismash {} antismash/{/.} -c CORES -v -t bacteria --fullhmmer --clusterhmmer --genefunctions-mite-version latest \
 --tigrfam --asf --cc-mibig --cb-general --cb-subclusters --cb-knownclusters --pfam2go --rre --smcog-trees' ::: *.gbk
```

#### Debugging

AntiSMASH will indicate the outcome of the analysis in the logs. 
For genbank files with no previously performed gene finding, antiSMASH will fail. 
In these cases, the additional option `--genefinding-tool prodigal` is required, which will first run gene detection on the genomes.

#### Read the output

Each antiSMASH output folder contains a index.html which can be opened in any browser to inspect the results.

### BiG-SCAPE

BiG-SCAPE allows to compare antiSMASH results from multiple genomes. 
It does so by comparing the enzyme motifs detected across genes container in BGCs, and clustering them based on their similarity.
The resulting network can be compared to a sequence similarity network. 
Further annotations by e.g. MIBiG allow to make assumption on the similarity of BGCs in a dataset and in comparison to external sources.

BiG-SCAPE is currently only available as a local installation (CLI with offline GUI).

#### Installation

BiG-SCAPE v2 can be installed to the local machine using mamba.

Mamba can be installed with the following commands:

```commandline
"${SHELL}" <(curl -L micro.mamba.pm)
source ~/.bashrc
```

BIG-SCAPE is then installed using:

```commandline
git clone https://github.com/medema-group/BiG-SCAPE
cd BiG-SCAPE
mamba env create -f environment.yml
mamba activate bigscape
pip install .
```

#### Running

BiG-SCAPE runs on previously created antiSMASH jobs (here, the `input/` directory) and writes its output in an output directory (here, `output`).

As prerequisite, a reference HMM library is needed and must be downloaded - usually, this is [PFAM](https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz). 
Unpack and place it next to the `input/` and `output/` folders.

Run BiG-SCAPE with the following commands:

```
bigscape cluster -i input/ --input-mode recursive -o output/ -p Pfam-A.hmm --mibig-version 4.0 --include-singletons --gcf-cutoffs 0.3,0.5,0.7
```

With these settings, all antiSMASH-detected BGCs will be detected in all directories of the `input/` directory and annotated using the PFAM database
Gene cluster families will be calculated using different cutoff values (`--gcf-cutoffs 0.3,0.5,0.7`) and compared to the MIBiG database.
Singletons will be included.

#### Interpreting the output

To inspect the BiG-SCAPE results, open the `index.html` file in any browser, and load the database file that was generated during the run.

These results can be used to compare e.g. the occurrence pattern of detected metabolites with the occurrence pattern of BGCs in strain genomes.

More information can be found in the [BiG-SCAPE Wiki](https://github.com/medema-group/BiG-SCAPE/wiki)

## How to get genomes 

After sequencing, assembly, and annotation, genomes are usually deposited on one of several genome repository.
The most important repository for bioinformatics is the NCBI database, which provides a rich source of genomic data.
However, due to historic reasons, it is not trivial to navigate the database and make sense of the different identifiers and concepts.

Here, we describe a simple workflow to get access to a (antiSMASH-compatible) genome in GenBank format. 
For details on identifiers, records, and NCBI in general, see [the database section](#primer-on-databases-and-identifiers)

### Genome assemblies (GCA): workflow using GUI

- If starting from Bioproject (i.e. the research project, identifier starting with `PRJNA`), identify the assembly accession ID. Usually, it starts with `GCA_...`. Click on the ID, which will direct you to the record page.
- On the assembly page, navigate to `Download`, select `GenBank only`, and select `Sequence and annotation (GBFF)`. Download to disk.
- Unpack the file and navigate to the folder containing the `.gbff` file. This file can be used with antiSMASH.

### Genome assemblies (GCA): workflow using CLI

Ideal to download multiple files. As previously, you need the assembly accession IDs (`GCA_...`).

First, install NCBI's `datasets` tool (assuming that `.local/bin` is in `$PATH`)

```commandline
curl -o ~/.local/bin/datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets'
curl -o ~/.local/bin/dataformat 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/dataformat'
chmod +x ~/.local/bin/datasets ~/.local/bin/dataformat
```

Create a text file with one assembly accession IDs per line, e.g.:

```text
GCA_12345678.1
GCA_987654321.1
```

Then, run the following commands for downloading accessions and unpacking them in a single folder.

```commandline
datasets download genome accession --inputfile assembly_accessions.txt --include gbff --filename genomes.zip
unzip genomes.zip -d genomes
mkdir gbffs
for d in genomes/ncbi_dataset/data/GCA_*/; do acc=$(basename "$d"); cp "$d/genomic.gbff" "gbffs/${acc}.gbk"; done
```

### Genbank or RefSeq records via GUI

Genomes can also be available as Genbank or RefSeq records (for details, see below).
Let assume we want to download the *Streptomyces coelicolor* genome sequence with the RefSeq ID `NC_003888.3`.

- On NCBI, search for [NC_003888.3](https://www.ncbi.nlm.nih.gov/nuccore/NC_003888.3)
- On the right-hand side, slick on the `Send to:` drop-down menu and under `Choose Destination` select `File`
- Download the file by clicking on `Create File`

### Genbank or RefSeq records via CLI

*Nota bene: assumes that the `uv` tool is installed*

For downloading multiple files, install the [ncbi-acc-download](https://github.com/kblin/ncbi-acc-download) tool

```commandline
uv tool install ncbi-acc-download
```

Then run the download

```commandline
ncbi-acc-download NC_003888.3
```

## Primer on databases and identifiers

TBA

## Pitfalls and FAQs

TBA