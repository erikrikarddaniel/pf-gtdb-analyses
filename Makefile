all: get_prefix sp_clusters.tsv 
	cd data; make $@
	 
RELEASE = latest

sp_clusters.tsv:
	wget https://data.ace.uq.edu.au/public/gtdb/data/releases/$$(RELEASE)/sp_clusters.tsv

sebset_reps:
	select_gtdb_representatives.R
	
PREFIX_1 = pfitmap-gtdb 
PREFIX_2 = pfitmap-RNRs-gtdb
    
subset_rnrs:
	select_RNR_related.R $$(PREFIX_1)
	select_RNR_related.R $$(PREFIX_2)
