#!/usr/bin/env Rscript

# select_sequences_in_GTDB_representatives.R
#
# Subsets sequences from genomes in the GTDB representatives list.
# Writes to feather files.
#
# Author: daniel.lundin@dbb.su.se, nouairia.ghada@gmail.com

suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(feather))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(stringr))

write("\tReading feather files", stderr())
accessions <- read_feather('pfitmap-gtdb.accessions.feather')
domains    <- read_feather('pfitmap-gtdb.domains.feather')
proteins   <- read_feather('pfitmap-gtdb.proteins.feather')
sequences  <- read_feather('pfitmap-gtdb.sequences.feather')
taxa       <- read_feather('pfitmap-gtdb.taxa.feather')
tblout     <- read_feather('pfitmap-gtdb.tblout.feather')
domtblout  <- read_feather('pfitmap-gtdb.domtblout.feather')

write("\tSubsetting tables to species representative genomes, writing to feather files prefixed with 'pfitmap-gtdb-rep'", stderr())
reps_accnos <- accessions %>%
  semi_join(taxa %>% filter (gtdb_representative == 't'), by = 'genome_accno')
write_feather (reps_accnos, "pfitmap-gtdb-rep.accessions.feather")

taxa %>%
  filter(gtdb_representative == 't') %>%
  write_feather("pfitmap-gtdb-rep.taxa.feather")

proteins %>% 
  semi_join(reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.proteins.feather")

domains %>% 
  semi_join(reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.domains.feather")

sequences %>%
  semi_join(reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.sequences.feather")

tblout %>% 
  semi_join(reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.tblout.feather")

domtblout %>%
  semi_join(reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.domtblout.feather")

write("\tDone", stderr())
