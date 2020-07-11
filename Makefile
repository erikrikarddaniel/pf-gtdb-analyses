all: sp_clusters.tsv
	cd data; make $@
	
RELEASE = latest

sp_clusters.tsv:
	wget https://data.ace.uq.edu.au/public/gtdb/data/releases/RELEASE/sp_clusters.tsv
