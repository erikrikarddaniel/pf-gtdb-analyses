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

accessions <- read_feather('pfitmap-gtdb.accessions.feather')
domains <- read_feather('pfitmap-gtdb.domains.feather')
proteins <- read_feather('pfitmap-gtdb.proteins.feather')
sequences <- read_feather('pfitmap-gtdb.sequences.feather')
taxa <- read_feather('pfitmap-gtdb.taxa.feather')
tblout <- read_feather('pfitmap-gtdb.tblout.feather')
domtblout <- read_feather('pfitmap-gtdb.domtblout.feather')

representatives <- read_tsv('sp_clusters.tsv') 
names(representatives)<-str_replace_all(names(representatives), c(" " = "."))

reps_accnos = accessions %>%
  mutate(genome = sub("GCA_", "", genome_accno)) %>%
  semi_join(representatives %>% 
              mutate (genome = sub("GB_GCA_", "", Representative.genome)) %>% mutate(genome = sub("RS_GCF_", "", genome)) %>% 
              mutate(genome = sub("\\.[1-9]", "", genome)), 
            by = 'genome') %>% 
  select(db, genome_accno, accno)

write_feather (reps_accnos, "pfitmap-gtdb-rep.accessions.feather")

taxa %>%
  semi_join(reps_accnos, by = 'genome_accno') %>%
  write_feather("pfitmap-gtdb-rep.taxa.feather")

proteins %>% 
    semi_join (reps_accnos, by = 'accno') %>%
    write_feather("pfitmap-gtdb-rep.proteins.feather")

domains %>% 
  semi_join (reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.domains.feather")

sequences %>%
  semi_join (reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.sequences.feather")

tblout %>% 
  semi_join (reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.tblout.feather")

domtblout %>%
  inner_join (reps_accnos, by = 'accno') %>%
  write_feather("pfitmap-gtdb-rep.domtblout.feather")