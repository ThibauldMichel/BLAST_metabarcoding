# BLAST_metabarcoding

## Description
The BLAST_metabarcoding pipeline has been developped to blast a list of ASVs barcodes to the NCBI nucleotides database and return the best matches and taxonomic and species identification.

## Directories
The BLAST script is located in the ```scripts``` directory, and paths are set up to run them from this location. The list of ASVs sequences to blast should be stored in the ```data``` directory.
The pipeline will create a ```results``` and a ```plots``` directories to store the output of the pipeline.

## How to run the pipeline?

### 1. Download the scripts
The directories of the pipeline can be downloaded at the location of your choice using the **<> Code** button above, or on BASH using the command:

```git clone git@github.com:ThibauldMichel/BLAST_metabarcoding.git```

### 2. Install the dependancies
The R dependances ```rentrez``` and ```dplyr``` are installed by the ```scripts/script_blast.R```.
[The package ```rentrez```](https://github.com/ropensci/rentrez) is used to send queries remotely to NCBI databases, no local datase is necessary to run the pipeline.

### 3. Set up the list of ASVs to blast
The list of ASVs to blast should be put in the ```data``` directory with the following format.

```ID1 Sequence1```

```ID2 Sequence2```

```ID3 Sequence3```

```ID4 Sequence4```

```etc...```

The pipeline will produce an intermediary ```1data/queries.fasta``` file processed by the rest of the pipeline.