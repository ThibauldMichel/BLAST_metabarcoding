# BLAST command
# https://www.ncbi.nlm.nih.gov/books/NBK569856/

# Output format
# https://www.metagenomics.wiki/tools/blast/blastn-output-format-6

# Install and load the modules.

# Package "rentrez" to import databases from NCBI:
# https://github.com/ropensci/rentrez
install.packages("rentrez")
library(rentrez)
library(dplyr)

#############################################################################################################
# make a fasta file of the queries from David file.

# Import David file:
table <- read.csv("../data/Taxonomy_Ciguarisk_5hits_blast_6000ASVs_DM_v2+RT_Corrected.csv")
sub <- table[c("ASV.number", "Seq")]

# Transform this list in fasta format with the following function:
#add ">" to headers
sub$ASV.number <- paste0(">",sub$ASV.number)

# bind rows of headers and seqs
seqs_fasta <- c(rbind(sub$ASV.number, sub$Seq))

# Write the FASTA file
write(x = seqs_fasta, file = "../data/queries.fasta")

#############################################################################################################
# Giving the path to the BLAST script.
blastn <- "blastn"

# Make the blast.
system2(
  blastn, 
  args = c(
      "-db nt",
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
      "-remote",
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

#############################################################################################################
# Incorporate taxonomy data:
# https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/35570-which-blast-output-format-can-give-full-taxonomony-information

# Warning: [blastn] Taxonomy name lookup from taxid requires installation of taxdb database with ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz


# Define taxonomy function:
# Function to retrieve taxonomy information using TaxID
get_lineage <- function(taxid) {
  # Define NCBI database and rettype (return type)
  db <- "taxonomy"
  rettype <- "xml"
  
  # Fetch taxonomy information using TaxID
  taxonomy_xml <- entrez_fetch(db, id = taxid, rettype = rettype)
  
  # Parse XML response
  taxonomy_parsed <- xml2::read_xml(taxonomy_xml)
  
  # Extract relevant taxonomy information
  taxon <- xml2::xml_find_first(taxonomy_parsed, ".//Taxon")
  species_name <- xml2::xml_text(xml2::xml_find_first(taxon, ".//ScientificName"))
  lineage <- xml2::xml_text(xml2::xml_find_first(taxon, ".//Lineage"))
  
  # Combine species name and lineage into a single output
  output <- paste(lineage)
  
  # Return combined output
  return(output)
}

get_species <- function(taxid) {
  # Define NCBI database and rettype (return type)
  db <- "taxonomy"
  rettype <- "xml"
  
  # Fetch taxonomy information using TaxID
  taxonomy_xml <- entrez_fetch(db, id = taxid, rettype = rettype)
  
  # Parse XML response
  taxonomy_parsed <- xml2::read_xml(taxonomy_xml)
  
  # Extract relevant taxonomy information
  taxon <- xml2::xml_find_first(taxonomy_parsed, ".//Taxon")
  species_name <- xml2::xml_text(xml2::xml_find_first(taxon, ".//ScientificName"))
  lineage <- xml2::xml_text(xml2::xml_find_first(taxon, ".//Lineage"))
  
  # Combine species name and lineage into a single output
  output <- paste(species_name)
  
  # Return combined output
  return(output)
}
#############################################################################################################

# Loop through the ID list, and get the taxonomy data
# Get list taxid:
tax <- as.list(df)
tax_id <- tax$staxids

# Loop with sapply:
lin_list <- sapply(tax_id, function(i) get_lineage(i))
spe_list <- sapply(tax_id, function(i) get_species(i))

# Implement this list as a column in the matrix:
df['Taxonomy'] <- lin_list
df['Species'] <- spe_list

# Save the table in format csv:
write.csv(df, "../results/table_query.csv")

#############################################################################################################

