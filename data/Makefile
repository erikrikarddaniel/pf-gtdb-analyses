SOURCE_DIR = sequoia:/data/gtdb_pfitmap/results/

all:
	rsync -avhLP --size-only $(SOURCE_DIR)/classification/*.feather ./.
	rsync -avhLP --size-only $(SOURCE_DIR)/metadata/gtdb_metadata.tsv ./.
	rsync -avhLP --size-only $(SOURCE_DIR)/genomes/all_genomes.gff.gz ./.
	make subset_reps
	make subset_rnrs_gtdb 
	make subset_rnrs_reps

clean:
	rm -f *.feather *.tsv subset_reps subset_rnrs_gtdb subset_rnrs_reps

subset_reps: pfitmap-gtdb.accessions.feather pfitmap-gtdb.domains.feather pfitmap-gtdb.taxa.feather pfitmap-gtdb.proteins.feather pfitmap-gtdb.sequences.feather pfitmap-gtdb.domtblout.feather pfitmap-gtdb.tblout.feather
	../scripts/select_gtdb_representatives.R
	@touch $@
    
subset_rnrs_gtdb: pfitmap-gtdb.accessions.feather pfitmap-gtdb.domains.feather pfitmap-gtdb.proteins.feather pfitmap-gtdb.sequences.feather pfitmap-gtdb.domtblout.feather pfitmap-gtdb.tblout.feather
	../scripts/select_RNR_related.R pfitmap-gtdb
	@touch $@

subset_rnrs_reps: pfitmap-gtdb-rep.accessions.feather pfitmap-gtdb-rep.domains.feather pfitmap-gtdb-rep.proteins.feather pfitmap-gtdb-rep.sequences.feather pfitmap-gtdb-rep.domtblout.feather pfitmap-gtdb-rep.tblout.feather
	../scripts/select_RNR_related.R pfitmap-gtdb-rep
	@touch $@

rnr_convenience_tables: pfitmap-gtdb-rep.taxa.feather pfitmap-gtdb.hmm_profiles.feather pfitmap-gtdb-rep-RNRs.accessions.feather pfitmap-gtdb-rep-RNRs.proteins.feather
	../scripts/rnr_convenience_tables.R
	@touch $@
