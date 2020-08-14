# Constants
NRDR_MIN_HMM_COVERAGE = 0.9

# Libraries
library(kfigr)
library(readr)
library(feather)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

accessions <- read_feather("data/pfitmap-gtdb-rep-RNRs.accessions.feather")
# dbsources <- read_feather('data/pfitmap-gtdb.dbsources.feather')
# domains <- read_feather('data/pfitmap-gtdb-rep-RNRs.domains.feather')
hmm_profiles <- read_feather('data/pfitmap-gtdb.hmm_profiles.feather')
proteins <- read_feather('data/pfitmap-gtdb-rep-RNRs.proteins.feather')
# sequences <- read_feather('data/pfitmap-gtdb-rep-RNRs.sequences.feather')
taxa <- read_feather('data/pfitmap-gtdb-rep.taxa.feather')
# tblout <- read_feather('data/pfitmap-gtdb-rep-RNRs.tblout.feather')
# domtblout <- read_feather('data/pfitmap-gtdb-rep-RNRs.domtblout.feather')

nrdrs <- hmm_profiles %>%
  filter(psuperfamily == 'NrdR-superfamily') %>%
  inner_join(proteins %>% filter((hmm_to - hmm_from + 1)/hmmlen >= NRDR_MIN_HMM_COVERAGE) , by = 'profile') %>%
  inner_join(accessions %>%  select(accno, genome_accno),  by = 'accno') %>%
  inner_join(taxa, by = 'genome_accno') %>%
  write_tsv(sprintf("./all_NrdRs.tsv"))

domain <- 'Bacteria'
level <- 'tphylum'

nrdr_by_level <- nrdrs %>%
  filter(tdomain == domain) %>%
  group_by_at(level) %>%
  distinct(genome_accno) %>%
  summarise(nrdr_pres_count = n()) %>%
  full_join(
    taxa %>%
      filter(tdomain == domain) %>%
      group_by_at(level) %>%
      summarise (genome_count = n()),
    by = level
  ) %>%
  replace_na(list(nrdr_pres_count = 0)) %>%
  mutate(proportion = nrdr_pres_count / genome_count) %>%
write_tsv(sprintf("./NrdR_proportions_in_%s_%s.tsv", domain, level))
