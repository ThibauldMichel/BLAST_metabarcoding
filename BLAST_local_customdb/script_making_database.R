# Reference article on taxonomic database:
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7408187/

# E-utilities for NCBI databases:
# https://www.ncbi.nlm.nih.gov/books/NBK25499/

# List of available blast NCBI databases:
# https://ftp.ncbi.nlm.nih.gov/blast/db/

if (!requireNamespace("xml2", quietly = TRUE)) {
  install.packages("xml2")}

if (!requireNamespace("magrittr", quietly = TRUE)) {
  install.packages("magrittr")}

library("xml2")
library("magrittr")


search_term <- "'large[All Fields] AND subunit[All Fields] AND ribosomal[All Fields] AND diatoms[All Fields]'"
db <- "nucleotide"

# Step 1: Perform the search and extract IDs
system2("esearch", args = c("-db", db, "-query", search_term, "|", "efetch", "-format", "uid", "|", "awk", "'{printf \"%s,\", $0}'", "|", "sed", "'s/,$//' > ../data/ids.txt"), wait = TRUE)

# Step 2: Fetch sequences using IDs
system2("efetch", args = c("-db", db, "-id", "$(cat ids.txt)", "-format", "fasta", ">", "../data/database_sequences.fasta"), wait = TRUE)

# Step 3: Fetch taxonomy data for each sequence ID
system2("efetch", args = c("-db", "taxonomy", "-id", "$(cat ids.txt)", "-format", "xml", ">", "../data/taxonomy_data.xml"), wait = TRUE)

# Step 4: Make database from the fasta file

## Define paths
fasta_file <- "../data/database_sequences.fasta"
db_name <- "../data/db_diatoms_seq"

## Create BLAST database
system2("makeblastdb", args = c("-in",
                                fasta_file, 
                                "-dbtype", 
                                "nucl", 
                                "-parse_seqids", 
                                "-out", 
                                db_name))

# Step 5: Parse taxonomy data and write to CSV

## Read the XML file
taxonomy <- read_xml("../data/taxonomy_data.xml")

## Find all Taxon nodes
taxon_nodes <- xml_find_all(taxonomy, "//Taxon")

## Initialize empty lists to store data
taxonomy_list <- list()

## Iterate over each Taxon node
for (node in taxon_nodes) {
  # Extract TaxId, ScientificName, and Lineage for the current Taxon node
  tax_id <- xml_text(xml_find_first(node, ".//TaxId"))
  scientific_name <- xml_text(xml_find_first(node, ".//ScientificName"))
  lineage <- xml_text(xml_find_first(node, ".//Lineage"))
  
  # Append the extracted values to the taxonomy_list
  taxonomy_list <- c(taxonomy_list, list(list(TaxId = tax_id, 
                                              ScientificName = scientific_name, 
                                              Lineage = lineage)))
}

## Convert the list of lists into a data frame
taxonomy_data <- do.call(rbind, lapply(taxonomy_list, unlist))

## Write the data frame to a CSV file
write.csv(taxonomy_data, file = "../data/taxonomy_database.csv", row.names = FALSE)
