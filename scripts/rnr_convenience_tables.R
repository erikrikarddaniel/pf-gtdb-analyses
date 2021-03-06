#!/usr/bin/env Rscript

# rnr_convenience_tables.R
#
# This scripts reads GTDB species representative RNR feather files (prefixed
# with "pfitmap-gtdb-rep-RNRs") and outputs tables that can be used by e.g.
# Rmarkdown analysis scripts for convenience. It is called by the "all" target
# in `data/Makefile`.
#
# Input tables:
#
#   pfitmap-gtdb-rep.taxa.feather
#   pfitmap-gtdb.hmm_profiles.feather
#   pfitmap-gtdb-rep-RNRs.accessions.feather
#   pfitmap-gtdb-rep-RNRs.proteins.feather
#
# Output tables:
#
#   pfitmap-gtdb-rep.taxa.feather (type changes, new columns)
#   pfitmap-gtdb.rnr_alphas.feather
#   pfitmap-gtdb-rep-RNRs.genomes_wo_rnr_alpha.feather
#   pfitmap-gtdb-rep-RNRs.rnr_class_combs.feather
#
# Author: daniel.lundin@dbb.su.se

suppressPackageStartupMessages(library(feather))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(stringr))

# Taxa: make sure some key columns are numeric, generate estimated genome
# size and genome size class columns.
write("\tCreating RNR convenience tables for GTDB representative genomes", stderr())
hmm_profiles <- read_feather("pfitmap-gtdb.hmm_profiles.feather")
accessions   <- read_feather("pfitmap-gtdb-rep-RNRs.accessions.feather")
proteins     <- read_feather("pfitmap-gtdb-rep-RNRs.proteins.feather")

write("\t  --> Replacing taxa table", stderr())
taxa <- read_feather("pfitmap-gtdb-rep.taxa.feather") %>%
  mutate(
    checkm_completeness = as.numeric(checkm_completeness),
    checkm_contamination = as.numeric(checkm_contamination),
    checkm_strain_heterogeneity = as.numeric(checkm_strain_heterogeneity),
    genome_size = as.numeric(genome_size),
    est_genome_size = genome_size/checkm_completeness*100,
    genome_size_class = ceiling(est_genome_size/1e6)
  )
# *Overwrite* the old table
write_feather(taxa, "pfitmap-gtdb-rep.taxa.feather")

# Profiles for RNR alpha subunits
write('\t  --> RNR alpha subunit profiles (pfitmap-gtdb.rnr_alphas.feather)', stderr())
rnr_alphas <- hmm_profiles %>% filter(pclass %in% c('NrdA', 'NrdD', 'NrdJ'))
write_feather(rnr_alphas, 'pfitmap-gtdb.rnr_alphas.feather')

# Genomes without RNRs
write("\t  --> Creating table with genomes lacking RNR alpha subunits (pfitmap-gtdb-rep-RNRs.genomes_wo_rnr_alpha.feather)", stderr())
taxa %>% 
  anti_join(
    rnr_alphas %>%
      inner_join(proteins, by = 'profile') %>%
      inner_join(accessions, by = 'accno'),
    by = "genome_accno"
  ) %>%
  write_feather('pfitmap-gtdb-rep-RNRs.genomes_wo_rnr_alpha.feather')

write('\t  --> RNR class combinations (pfitmap-gtdb-rep-RNRs.rnr_class_combs.feather)', stderr())
rnr_alphas %>%
  inner_join(proteins, by = 'profile') %>%
  inner_join(accessions, by = 'accno') %>%
  distinct(genome_accno, pclass) %>%
  pivot_wider(names_from = pclass, values_from = pclass) %>%
  unite(rnr_combination, NrdA, NrdD, NrdJ, sep = ':', na.rm = TRUE) %>%
  mutate(
    rnr_combination = factor(
      rnr_combination,
      levels = c('NrdA', 'NrdJ', 'NrdD', 'NrdA:NrdJ', 'NrdA:NrdD', 'NrdD:NrdJ', 'NrdA:NrdD:NrdJ'),
      ordered = TRUE
    )
  ) %>%
  inner_join(taxa, by = 'genome_accno') %>%
  write_feather('pfitmap-gtdb-rep-RNRs.rnr_class_combs.feather')

# Phylum sets of various sizes
counted_phyla <- taxa %>% count(tdomain, tphylum, name = 'n_species')
tibble(n= c(11, 20, 50)) %>%
  mutate(
    d = purrr::map(
      n,
      function(n_taxa) {
        counted_phyla %>% group_by(tdomain) %>% top_n(n_taxa, n_species) %>% 
          mutate(n_taxa_level = sprintf("top%dphyla", n_taxa))
      }
    )
  ) %>%
  unnest(d) %>%
  select(-n, -n_species) %>%
  mutate(ph = tphylum) %>%
  pivot_wider(names_from = n_taxa_level, values_from = ph) %>%
  right_join(counted_phyla, by = c('tdomain', 'tphylum')) %>%
  mutate(
    top11phyla = forcats::fct_explicit_na(top11phyla, na_level = 'Other phyla'),
    top20phyla = forcats::fct_explicit_na(top20phyla, na_level = 'Other phyla'),
    top50phyla = forcats::fct_explicit_na(top50phyla, na_level = 'Other phyla')
  ) %>%
  write_feather('pfitmap-gtdb-rep.topphyla.feather')
