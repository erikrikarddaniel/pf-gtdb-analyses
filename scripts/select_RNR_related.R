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

prefix = commandArgs(trailingOnly=TRUE)

accessions <- read_feather(sprintf("%s.accessions.feather", prefix))
hmm_profiles <- read_feather(sprintf("%s.hmm_profiles.feather", prefix))
domains <- read_feather(sprintf("%s.domains.feather", prefix))
proteins <- read_feather(sprintf("%s.proteins.feather", prefix))
sequences <- read_feather(sprintf("%s.sequences.feather", prefix))
tblout <- read_feather(sprintf("%s.tblout.feather", prefix))
domtblout <- read_feather(sprintf("%s.domtblout.feather", prefix))

rnrs = hmm_profiles %>% 
  inner_join(proteins, by = 'profile') %>%
  filter (psuperfamily %in% c('Ferritin-like', 'NrdGRE', 'Flavodoxin superfamily', 'NrdR-superfamily')) %>%
  select(accno, profile)

proteins %>% 
  inner_join (rnrs %>% select (accno), by = 'accno') %>%
  write_feather(sprintf("%s-RNRs.proteins.feather", prefix))

accessions %>% 
  inner_join (rnrs %>% select (accno), by = 'accno') %>%
  write_feather(sprintf("%s-RNRs.accessions.feather", prefix))

domains %>% 
   inner_join (rnrs, by = c('accno', 'profile')) %>%
  write_feather(sprintf("%s-RNRs.domains.feather", prefix))
  
sequences %>%
  inner_join (rnrs %>% select (accno), by = 'accno') %>%
  write_feather(sprintf("%s-RNRs.sequences.feather", prefix))

tblout %>% 
  inner_join (rnrs, by = c('accno', 'profile')) %>%
  write_feather(sprintf("%s-RNRs.tblout.feather", prefix))

domtblout %>%
  inner_join (rnrs, by = c('accno', 'profile')) %>%
  write_feather(sprintf("%s-RNRs.domtblout.feather", prefix))
