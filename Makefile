all: get_prefix sp_clusters.tsv 
	cd data; make $@
	 
RELEASE = latest

sp_clusters.tsv:
	wget https://data.ace.uq.edu.au/public/gtdb/data/releases/RELEASE/sp_clusters.tsv

sebset_reps:
	select_gtdb_representatives.R
	
get_prefix:
    @echo "Choose data to subset: pfitmap-gtdb or pfitmap-RNRs-gtdb"; \
    read prefix;
    
subset_rnrs:
	select_RNR_related.R $$(prefix)
