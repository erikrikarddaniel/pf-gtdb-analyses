all: download_data sp_clusters.tsv subset_reps subset_rnrs_in_gtdb subset_rnrs_in_reps
	cd data; make $@
	 
download_data:
	rsync sequoia:pfitmap-gtdb.accessions.feather
	rsync sequoia:pfitmap-gtdb.dbsources.feather
	rsync sequoia:pfitmap-gtdb.hmm_profiles.feather
	rsync sequoia:pfitmap-gtdb.proteins.feather
	rsync sequoia:pfitmap-gtdb.taxa.feather
	rsync sequoia:pfitmap-gtdb.domains.feather
	rsync sequoia:pfitmap-gtdb.domtblout.feather 
	rsync sequoia:pfitmap-gtdb.tblout.feather
	rsync sequoia:pfitmap-gtdb.sequences.feather

RELEASE = latest

sp_clusters.tsv:
	wget https://data.ace.uq.edu.au/public/gtdb/data/releases/$$(RELEASE)/sp_clusters.tsv

subset_reps: download_data sp_clusters.tsv
	select_gtdb_representatives.R
    
subset_rnrs_in_gtdb: download_data 
	select_RNR_related.R pfitmap-gtdb

subset_rnrs_in_reps: subset_reps
	select_RNR_related.R pfitmap-gtdb-rep	
