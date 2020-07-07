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

accessions <- read_feather('pfitmap-gtdb-rep.accessions.feather')
hmm_profiles <- read_feather('pfitmap-gtdb.hmm_profiles.feather')
domains <- read_feather('pfitmap-gtdb-rep.domains.feather')
proteins <- read_feather('pfitmap-gtdb-rep.proteins.feather')
sequences <- read_feather('pfitmap-gtdb-rep.sequences.feather')
tblout <- read_feather('pfitmap-gtdb-rep.tblout.feather')
domtblout <- read_feather('pfitmap-gtdb-rep.domtblout.feather')

RNR_accnos = hmm_profiles %>% 
  inner_join(proteins, by = 'profile') %>%
  filter (psuperfamily %in% c('Ferritin-like', 'NrdGRE', 'Flavodoxin superfamily', 'NrdR-superfamily')) %>%
  select (accno)

proteins %>% 
    inner_join (RNR_accnos, by = 'accno') %>%
    write_feather("pfitmap-RNRs-gtdb-rep.proteins.feather")

accessions %>% 
  inner_join (RNR_accnos, by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.accessions.feather")

domains %>% 
  inner_join (RNR_accnos, by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.domains.feather")
  
sequences %>%
  inner_join (RNR_accnos, by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.sequences.feather")
  
tblout %>% 
  inner_join (RNR_accnos, by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.tblout.feather")

domtblout %>%
  inner_join (RNR_accnos, by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.domtblout.feather")