#!/usr/bin/env Rscript

# select RNR related proteins in GTDB and in GTDB representatives
#
# Subsets sequences from genomes in the GTDB representatives list. Subsets proteins in RNR related protein profiles
# Writes to feather files.
#
# Author: daniel.lundin@dbb.su.se, nouairia.ghada@gmail.com
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(feather))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(stringr))

accessions <- read_feather('pfitmap-gtdb.accessions.feather')
hmm_profiles <- read_feather('pfitmap-gtdb.hmm_profiles.feather')
domains <- read_feather('pfitmap-gtdb.domains.feather')
proteins <- read_feather('pfitmap-gtdb.proteins.feather')
sequences <- read_feather('pfitmap-gtdb.sequences.feather')
tblout <- read_feather('pfitmap-gtdb.tblout.feather')
domtblout <- read_feather('pfitmap-gtdb.domtblout.feather')

representatives <- read_tsv('sp_clusters.tsv') 
names(representatives)<-str_replace_all(names(representatives), c(" " = "."))

RNR_accnos = hmm_profiles %>% 
  inner_join(proteins, by = 'profile') %>%
  filter (psuperfamily %in% c('Ferritin-like', 'NrdGRE', 'Flavodoxin superfamily', 'NrdR-superfamily')) %>%
  select(accno, profile)

RNR_rep_accnos = accessions %>%
  mutate(genome = sub("GCA_", "", genome_accno)) %>%
  semi_join(representatives %>% 
              mutate (genome = sub("GB_GCA_", "", Representative.genome)) %>% mutate(genome = sub("RS_GCF_", "", genome)) %>% 
              mutate(genome = sub("\\.[1-9]", "", genome)), 
            by = 'genome') %>%
  inner_join(RNR_accnos, by = 'accno') %>%
  select (accno, profile)

proteins %>% 
  inner_join (RNR_accnos %>% select (accno), by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb.proteins.feather")

proteins %>% 
    inner_join (RNR_rep_accnos %>% select (accno), by = 'accno') %>%
    write_feather("pfitmap-RNRs-gtdb-rep.proteins.feather")

accessions %>% 
  inner_join (RNR_accnos %>% select (accno), by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb.accessions.feather")

accessions %>% 
  inner_join (RNR_rep_accnos %>% select (accno), by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.accessions.feather")

domains %>% 
   inner_join (RNR_accnos, by = c('accno', 'profile')) %>%
  write_feather("pfitmap-RNRs-gtdb.domains.feather")
  
domains %>% 
  inner_join (RNR_rep_accnos, by = c('accno', 'profile')) %>%
  write_feather("pfitmap-RNRs-gtdb-rep.domains.feather")

sequences %>%
  inner_join (RNR_accnos %>% select (accno), by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb.sequences.feather")
  
sequences %>%
  inner_join (RNR_rep_accnos %>% select (accno), by = 'accno') %>%
  write_feather("pfitmap-RNRs-gtdb-rep.sequences.feather")

tblout %>% 
  inner_join (RNR_accnos, by = c('accno', 'profile')) %>%
  write_feather("pfitmap-RNRs-gtdb.tblout.feather")

tblout %>% 
  inner_join (RNR_rep_accnos, by = c('accno', 'profile')) %>%
  write_feather("pfitmap-RNRs-gtdb-rep.tblout.feather")

domtblout %>%
  inner_join (RNR_accnos, by = c('accno', 'profile')) %>%
  write_feather("pfitmap-RNRs-gtdb.domtblout.feather")

domtblout %>%
  inner_join (RNR_rep_accnos, by = c('accno', 'profile')) %>%
  write_feather("pfitmap-RNRs-gtdb-rep.domtblout.feather")