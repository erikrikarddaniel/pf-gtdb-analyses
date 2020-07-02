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

representatives <- read_tsv('sp_clusters.tsv') 
names(representatives)<-str_replace_all(names(representatives), c(" " = "."))

taxa %>%
  mutate(genome = sub("GCA_", "", genome_accno)) %>%
  semi_join(representatives %>% 
              mutate (genome = sub("GB_GCA_", "", Representative.genome)) %>% mutate(genome = sub("RS_GCF_", "", genome)) %>% 
              mutate(genome = sub("\\.[1-9]", "", genome)), 
            by = 'genome') %>%
  select(genome_accno, tdomain, tphylum, tclass, torder, tfamily, tgenus, tspecies, trank, ncbi_taxon_id) %>%
  write_feather("pfitmap-gtdb-rep.taxa.feather")

accessions %>%
  mutate(genome = sub("GCA_", "", genome_accno)) %>%
  semi_join(representatives %>% 
              mutate (genome = sub("GB_GCA_", "", Representative.genome)) %>% mutate(genome = sub("RS_GCF_", "", genome)) %>% 
              mutate(genome = sub("\\.[1-9]", "", genome)), 
            by = 'genome') %>%
  select(db, genome_accno, accno) %>%
  write_feather("pfitmap-gtdb-rep.accessions.feather")

proteins %>% 
  inner_join (accessions %>%
                mutate(genome = sub("GCA_", "", genome_accno)) %>%
                semi_join(representatives %>% 
                            mutate (genome = sub("GB_GCA_", "", Representative.genome)) %>% mutate(genome = sub("RS_GCF_", "", genome)) %>% 
                            mutate(genome = sub("\\.[1-9]", "", genome)), 
            by = 'genome'), 
            by = 'accno') %>%
  select(accno, profile, score, evalue, tlen, qlen, ali_from, ali_to, alilen, env_from, env_to, envlen, hmm_from, hmm_to, hmmlen) %>%
  write_feather("pfitmap-gtdb-rep.proteins.feather")

domains %>% 
  inner_join (accessions %>%
                mutate(genome = sub("GCA_", "", genome_accno)) %>%
                semi_join(representatives %>% 
                            mutate (genome = sub("GB_GCA_", "", Representative.genome)) %>% mutate(genome = sub("RS_GCF_", "", genome)) %>% 
                            mutate(genome = sub("\\.[1-9]", "", genome)), 
                          by = 'genome'), 
              by = 'accno') %>%
  select(accno, profile, i, n, dom_c_evalue, dom_i_evalue, dom_score, hmm_from, hmm_to, ali_from, ali_to, env_from, env_to) %>%
  write_feather("pfitmap-gtdb-rep.domains.feather")

