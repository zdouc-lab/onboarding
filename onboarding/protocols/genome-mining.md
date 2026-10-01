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
- [Primer on databases and identifiers]()
- [Pitfalls and FAQs]()

## Introduction

Genome sequencing creates huge amounts of information that cannot be interpreted manually. 
Therefore, researchers have developed software tools to help parsing, annotating, and interpreting data.

Broadly, these tools can be categorized into:

- Rule-based tools (built upon rules drawn from scientific observations; reliable but biased towards existing literature)
- Machine learning-based tools (trained on labeled or unlabeled data; less reliable but more permissive towards non-canonical findings)

This protocol/tutorial focuses on established, rule-based tools, which are good for "everyday use"

## Important tools and how to install them

### antiSMASH

#### Installation

TBA

#### Running the tool

TBA

#### Interpreting the output

TBA

### BiG-SCAPE

#### Installation

TBA

#### Running the tool

TBA

#### Interpreting the output

TBA

## How to get genomes 

After sequencing, assembly, and annotation, genomes are usually deposited on one of several genome repository.
The most important repository for bioinformatics is the NCBI database, which provides a rich source of genomic data.
However, due to historic reasons, it is not trivial to navigate the database and make sense of the different identifiers and concepts.

Here, we describe a simple workflow to get access to a (antiSMASH-compatible) genome in GenBank format. For details on identifiers, records, and NCBI in general, see [the database section](#primer-on-databases-and-identifiers)

### Installation

For single genomes, download can be performed via the website graphical user interface. 
For multiple entries, we should use a command line tool.


### Genome assemblies (GCA): workflow using GUI

- If starting from Bioproject (i.e. the research project, identifier starting with `PRJNA`), identify the assembly accession ID. Usually, it starts with `GCA_...`. Click on the ID, which will direct you to the record page.
- On the assembly page, navigate to `Download`, select `GenBank only`, and select `Sequence and annotation (GBFF)`. Download to disk.
- Unpack the file and naviage to the folder containing the `.gbff` file. This file can be used with antiSMASH.

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




## Primer on databases and identifiers

TBA