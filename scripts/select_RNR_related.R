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

# prefix = commandArgs(trailingOnly=TRUE)
prefix = "pfitmap-gtdb-rep"

accessions <- read_feather(sprintf("../data/%s.accessions.feather", prefix))
hmm_profiles <- read_feather("../data/pfitmap-gtdb.hmm_profiles.feather")
domains <- read_feather(sprintf("../data/%s.domains.feather", prefix))
proteins <- read_feather(sprintf("../data/%s.proteins.feather", prefix))
sequences <- read_feather(sprintf("../data/%s.sequences.feather", prefix))
tblout <- read_feather(sprintf("../data/%s.tblout.feather", prefix))
domtblout <- read_feather(sprintf("../data/%s.domtblout.feather", prefix))

rnrs = hmm_profiles %>% 
  inner_join(proteins, by = 'profile') %>%
  filter (psuperfamily %in% c('Ferritin-like', 'NrdGRE', 'Flavodoxin superfamily', 'NrdR-superfamily')) %>%
  select(accno, profile)

proteins %>% 
  inner_join (rnrs %>% select (accno), by = 'accno') %>%
  write_feather(sprintf("../data/%s-RNRs.proteins.feather", prefix))

accessions %>% 
  inner_join (rnrs %>% select (accno), by = 'accno') %>%
  write_feather(sprintf("../data/%s-RNRs.accessions.feather", prefix))

domains %>% 
   inner_join (rnrs, by = c('accno', 'profile')) %>%
  write_feather(sprintf("../data/%s-RNRs.domains.feather", prefix))
  
sequences %>%
  inner_join (rnrs %>% select (accno), by = 'accno') %>%
  write_feather(sprintf("../data/%s-RNRs.sequences.feather", prefix))

tblout %>% 
  inner_join (rnrs, by = c('accno', 'profile')) %>%
  write_feather(sprintf("../data/%s-RNRs.tblout.feather", prefix))

domtblout %>%
  inner_join (rnrs, by = c('accno', 'profile')) %>%
  write_feather(sprintf("../data/%s-RNRs.domtblout.feather", prefix))

