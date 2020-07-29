SOURCE_DIR = sequoia:/data/gtdb_pfitmap/results/

all:
	rsync -avhLP --size-only $(SOURCE_DIR)/*.feather ./.
	rsync -avhLP --size-only $(SOURCE_DIR)/gtdb_metadata.tsv ./.
	make subset_rnrs_gtdb subset_reps 
	make subset_rnrs_reps
	
subset_reps: pfitmap-gtdb.accessions.feather pfitmap-gtdb.domains.feather pfitmap-gtdb.taxa.feather pfitmap-gtdb.proteins.feather pfitmap-gtdb.sequences.feather pfitmap-gtdb.domtblout.feather pfitmap-gtdb.tblout.feather
	select_gtdb_representatives.R
	touch $@
    
subset_rnrs_gtdb: pfitmap-gtdb.accessions.feather pfitmap-gtdb.domains.feather pfitmap-gtdb.proteins.feather pfitmap-gtdb.sequences.feather pfitmap-gtdb.domtblout.feather pfitmap-gtdb.tblout.feather
	select_RNR_related.R pfitmap-gtdb
	touch $@

subset_rnrs_reps: pfitmap-gtdb-rep.accessions.feather pfitmap-gtdb-rep.domains.feather pfitmap-gtdb-rep.proteins.feather pfitmap-gtdb-rep.sequences.feather pfitmap-gtdb-rep.domtblout.feather pfitmap-gtdb-rep.tblout.feather
	select_RNR_related.R pfitmap-gtdb-rep	
	touch $
