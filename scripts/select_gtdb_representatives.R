#!/usr/bin/env Rscript

# select_sequences_in_GTDB_representatives.R
#
# Subsets sequences from genomes in the GTDB representatives list.
# Writes to feather files.
#
# Author: daniel.lundin@dbb.su.se, nouairia.ghada@gmail.com

suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(feather))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(dtplyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(stringr))

accessions <- read_feather('pfitmap-gtdb.accessions.feather') %>% as.data.table()
taxa       <- read_feather('pfitmap-gtdb.taxa.feather') %>% as.data.table()
### domains    <- read_feather('pfitmap-gtdb.domains.feather')
### proteins   <- read_feather('pfitmap-gtdb.proteins.feather')
### sequences  <- read_feather('pfitmap-gtdb.sequences.feather')
### tblout     <- read_feather('pfitmap-gtdb.tblout.feather')
### domtblout  <- read_feather('pfitmap-gtdb.domtblout.feather')

write("\tReading feather files, subsetting tables to species representative genomes, writing to feather files prefixed with 'pfitmap-gtdb-rep'", stderr())
reps_accnos <- lazy_dt(accessions) %>%
  semi_join(lazy_dt(taxa) %>% filter(gtdb_representative == 't'), by = 'genome_accno') %>%
  as.data.table()
write_feather(reps_accnos, "pfitmap-gtdb-rep.accessions.feather")
write("\t  --> accessions written", stderr())

lazy_dt(taxa) %>%
  filter(gtdb_representative == 't') %>%
  as.data.table() %>%
  write_feather("pfitmap-gtdb-rep.taxa.feather")
write("\t  --> taxa written", stderr())
rm(taxa)

read_feather("pfitmap-gtdb.proteins.feather") %>% as.data.table() %>% lazy_dt() %>% 
  semi_join(reps_accnos, by = 'accno') %>%
  as.data.table() %>%
  write_feather("pfitmap-gtdb-rep.proteins.feather")
write("\t  --> proteins written", stderr())

read_feather("pfitmap-gtdb.domains.feather") %>% as.data.table() %>% lazy_dt() %>% 
  semi_join(reps_accnos, by = 'accno') %>%
  as.data.table() %>%
  write_feather("pfitmap-gtdb-rep.domains.feather")
write("\t  --> domains written", stderr())

read_feather("pfitmap-gtdb.sequences.feather") %>% as.data.table() %>% lazy_dt() %>%
  semi_join(reps_accnos, by = 'accno') %>%
  as.data.table() %>%
  write_feather("pfitmap-gtdb-rep.sequences.feather")
write("\t  --> sequences written", stderr())

read_feather("pfitmap-gtdb.tblout.feather") %>% as.data.table() %>% lazy_dt() %>% 
  semi_join(reps_accnos, by = 'accno') %>%
  as.data.table() %>%
  write_feather("pfitmap-gtdb-rep.tblout.feather")
write("\t  --> tblout written", stderr())

read_feather("pfitmap-gtdb.domtblout.feather") %>% as.data.table() %>% lazy_dt() %>%
  semi_join(reps_accnos, by = 'accno') %>%
  as.data.table() %>%
  write_feather("pfitmap-gtdb-rep.domtblout.feather")
write("\t  --> domtblout written", stderr())

write("\tDone", stderr())
