all: download_data  
	cd data; make $@
	make subset_rnrs_gtdb subset_reps 
	make subset_rnrs_reps
	
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

subset_reps: pfitmap-gtdb.accessions.feather pfitmap-gtdb.domains.feather pfitmap-gtdb.taxa.feather pfitmap-gtdb.proteins.feather pfitmap-gtdb.sequences.feather pfitmap-gtdb.domtblout.feather pfitmap-gtdb.tblout.feather sp_clusters.tsv
	select_gtdb_representatives.R
	touch $@
    
subset_rnrs_gtdb: pfitmap-gtdb.accessions.feather pfitmap-gtdb.domains.feather pfitmap-gtdb.proteins.feather pfitmap-gtdb.sequences.feather pfitmap-gtdb.domtblout.feather pfitmap-gtdb.tblout.feather
	select_RNR_related.R pfitmap-gtdb
	touch $@

subset_rnrs_reps: pfitmap-gtdb-rep.accessions.feather pfitmap-gtdb-rep.domains.feather pfitmap-gtdb-rep.proteins.feather pfitmap-gtdb-rep.sequences.feather pfitmap-gtdb-rep.domtblout.feather pfitmap-gtdb-rep.tblout.feather
	select_RNR_related.R pfitmap-gtdb-rep	
	touch $@
