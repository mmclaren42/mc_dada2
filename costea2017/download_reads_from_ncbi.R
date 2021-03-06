# Download the sequence data for the samples in the Costea2017 Phase 3
# experiment

library(tidyverse)

dotenv::load_dot_env("../.env")
script_path <- getwd()
data_path <- file.path(Sys.getenv("DATA_DIR"),
    "costea2017")

# The sample metadata generated by `sample_metadata.R` includes the run
# accessions that we need for downloading from NCBI or ENA
tb <- readr::read_csv(file.path(script_path, "sample_metadata.csv"))

# Use prefetch to download with ascp if available, and fall back to http
# otherwise.
command <- paste("prefetch", 
    "--ascp-path", Sys.getenv("ASCP_PATH") %>% shQuote,
    paste(tb$Run_accession, collapse=" "))
system(command)
# Convert to fastq
command <- paste("fastq-dump --gzip",
    "--outdir", file.path(data_path, "reads"),
    paste(tb$Run_accession, collapse=" "))
system(command)
# Note, will download the .sra files to whatever directory is set by the sra
# toolkit config. These can be deleted after converting to fastq.
# Set this directory with `vdb-config` (see
# https://github.com/ncbi/sra-tools/wiki/Toolkit-Configuration)

# TODO: Delete the .sra files after fastq conversion (?)
# Also, see https://github.com/ncbi/sra-tools/issues/71 to consider alternate
# method
