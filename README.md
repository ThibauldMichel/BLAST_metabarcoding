# BLAST_metabarcoding

## Description
The BLAST_metabarcoding pipeline has been developped to blast a list of ASVs barcodes to the NCBI nucleotides database and return the best matches and taxonomic and species identification.

## Directories
The BLAST script is located in the ```scripts``` directory, and paths are set up to run them from this location. The list of ASVs sequences to blast should be stored in the ```data``` directory.
The pipeline will create a ```results``` and a ```plots``` directories to store the output of the pipeline.

## How to run the pipeline?

### Dependancies
The R dependances ```rentrez``` and ```dplyr``` are installed by the ```scripts/script_blast.R```.
[The package ```rentrez```](https://github.com/ropensci/rentrez) is used to send queries remotely to NCBI databases, no local datase is necessary to run the pipeline.

### Set up the list of ASVs to blast
The list of ASVs to blast should be put in the ```data``` directory.
