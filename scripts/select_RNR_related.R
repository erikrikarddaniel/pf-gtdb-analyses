#!/usr/bin/env Rscript

# select RNR related proteins in GTDB and in GTDB representatives
#
# Subsets sequences from genomes in the GTDB representatives list. Subsets proteins in RNR related protein profiles
# Writes to feather files.
#
# Author: daniel.lundin@dbb.su.se, nouairia.ghada@gmail.com
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(feather))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(dtplyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(stringr))

prefix = commandArgs(trailingOnly=TRUE)

write(sprintf("\tReading feather files prefixed with '%s', subsetting tables to RNR protein entries, writing to feather files prefixed with 'pfitmap-gtdb-rep'", prefix), stderr())
hmm_profiles <- read_feather("pfitmap-gtdb.hmm_profiles.feather") %>% as.data.table()
proteins <- read_feather(sprintf("%s.proteins.feather", prefix)) %>% as.data.table()

rnrs = hmm_profiles %>% lazy_dt() %>%
  inner_join(lazy_dt(proteins), by = 'profile') %>%
  filter(psuperfamily %in% c('Ferritin-like', 'NrdGRE', 'Flavodoxin superfamily', 'NrdR-superfamily')) %>%
  select(accno, profile) %>%
  as.data.table()

proteins %>% lazy_dt() %>%
  inner_join(lazy_dt(rnrs) %>% select (accno), by = 'accno') %>%
  as.data.table() %>%
  write_feather(sprintf("%s-RNRs.proteins.feather", prefix))
write("	  --> proteins written", stderr())
rm(proteins)

read_feather(sprintf("%s.accessions.feather", prefix)) %>% as.data.table() %>% lazy_dt() %>%
  inner_join(lazy_dt(rnrs) %>% select (accno), by = 'accno') %>%
  as.data.table() %>%
  write_feather(sprintf("%s-RNRs.accessions.feather", prefix))
write("	  --> accessions written", stderr())

read_feather(sprintf("%s.domains.feather", prefix)) %>% as.data.table() %>% lazy_dt() %>%
  inner_join(lazy_dt(rnrs), by = c('accno', 'profile')) %>%
  as.data.table() %>%
  write_feather(sprintf("%s-RNRs.domains.feather", prefix))
write("	  --> domains written", stderr())
  
read_feather(sprintf("%s.sequences.feather", prefix)) %>% as.data.table() %>% lazy_dt() %>%
  inner_join(lazy_dt(rnrs) %>% select (accno), by = 'accno') %>%
  as.data.table() %>%
  write_feather(sprintf("%s-RNRs.sequences.feather", prefix))
write("	  --> sequences written", stderr())

read_feather(sprintf("%s.tblout.feather", prefix)) %>% as.data.table() %>% lazy_dt() %>%
  inner_join(lazy_dt(rnrs), by = c('accno', 'profile')) %>%
  as.data.table() %>%
  write_feather(sprintf("%s-RNRs.tblout.feather", prefix))
write("	  --> tblout written", stderr())

read_feather(sprintf("%s.domtblout.feather", prefix)) %>% as.data.table() %>% lazy_dt() %>%
  inner_join(lazy_dt(rnrs), by = c('accno', 'profile')) %>%
  as.data.table() %>%
  write_feather(sprintf("%s-RNRs.domtblout.feather", prefix))
write("	  --> domtblout written", stderr())

write("\tDone", stderr())
