# BLAST command
# https://www.ncbi.nlm.nih.gov/books/NBK569856/

# Output format
# https://www.metagenomics.wiki/tools/blast/blastn-output-format-6

# Rentrez syntax
# https://github.com/ropensci/rentrez

# NCBI guidelines
# https://www.ncbi.nlm.nih.gov/books/NBK179288/

############################################################################################################

# Install and load the modules.

# Package "rentrez" to import databases from NCBI:
# https://github.com/ropensci/rentrez
if (!require("rentrez")) install.packages("rentrez", repos = "http://cran.us.r-project.org")
if (!require("dplyr")) install.packages("dplyr", repos = "http://cran.us.r-project.org")

library(rentrez)
library(dplyr)

############################################################################################################

# Set up the directories

# Your path to the raw reads here:
path_data <- file.path("..", "data")

# Path to the outputs of the pipeline:
path_results <- file.path("..", "results")
if(!dir.exists(path_results)) dir.create(path_results)

# Create directory for plots:
path_plots <- file.path("..", "plots")
if(!dir.exists(path_plots)) dir.create(path_plots)


#############################################################################################################
# make a fasta file of the queries from David file.

# Import David file:
#table <- file.path(path_data, "Taxonomy_Ciguarisk_5hits_blast_6000ASVs_DM_v2+RT_Corrected.csv")
#sub <- table[c("ASV.number", "Seq")]

# Transform this list in fasta format with the following function:
#add ">" to headers
#sub[["ASV.number"]] <- paste0(">",sub[["ASV.number"]])

# bind rows of headers and seqs
#seqs_fasta <- c(rbind(sub[["ASV.number"]], sub[["Seq"]]))

# Write the FASTA file
#write(x = seqs_fasta, file = file.path(path_data, "queries.fasta")

#############################################################################################################

# Giving the path to the BLAST script.
blastn <- "blastn"


# Make the blast.
system2(
  blastn, 
  args = c(
      "-db ../data/db_diatoms_seq",
      #db_name,
      "-query ../data/queries.fasta",
      "-out ../results/results.csv",
      "-outfmt '6 delim=@ 
      qseqid 
      sseqid 
      pident 
      length 
      sacc 
      slen 
      evalue 
      bitscore 
      score 
      staxids' ",
      "-evalue 1e-20",
      #"-remote",
      "-max_target_seqs 5"#,
      #"2> /dev/null"
)
)

# Formating the data with correct columns names:
# Load data:
df <- read.csv("../results/results.csv", sep="@")

# Define columns names:
columns_names <- c(
  "qseqid",
  "sseqid",
  "pident",
  "length",
  "sacc",
  "slen",
  "evalue",
  "bitscore",
  "score",
  "staxids"
)

# Input names in the matrix:
names(df) <- columns_names

write.csv(df, file='../results/outputs_named.csv')
