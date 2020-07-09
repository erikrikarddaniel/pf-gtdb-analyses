SOURCE_DIR = sequoia:/data/gtdb_pfitmap/results/

all:
	rsync -avhLP --size-only $(SOURCE_DIR)/*.feather ./.
	rsync -avhLP --size-only $(SOURCE_DIR)/gtdb_metadata.tsv ./.
	rsync -avhLP --size-only $(SOURCE_DIR)/sp_clusters.tsv ./.
