import numpy as np 
import glob
import os 
import umap
import numpy as np

TOTAL_SAMPLE_SIZE = 100
SLICE_SIZE = 10
SAMPLE_SIZE_PER_SLICE = TOTAL_SAMPLE_SIZE / SLICE_SIZE
LATENT_VECTOR_SIZE = 128
UMAP_NEIGHBOURS = 50
UMAP_MIN_DISTATNCE = 0.1
UMAP_DIMENSIONS = 2
OUTPUT_PATH = "./output/"
CSV_FILENAME = "random_nums_3d_embeddings"
CSV_HEADER = "x, y, slice_id, id"
CSV_COMMENTS = "" # should the csv header have any text before the labels? (like '#' for python comment)
CSV_FMT = "%f" #fmt "%f" ensures floats are not saved in the sci annotation format to to the csv file


def main():
	assert(TOTAL_SAMPLE_SIZE % SLICE_SIZE == 0)
	# get a huge sample of random numbers
	total_sample = np.random.normal(0, 1, (TOTAL_SAMPLE_SIZE, LATENT_VECTOR_SIZE))
	print("Running umap")	
	# reduce the dimensions of the sample to 2-3 dims 
	reducer = umap.UMAP(n_neighbors=UMAP_NEIGHBOURS, min_dist=UMAP_MIN_DISTATNCE, n_components=UMAP_DIMENSIONS)
	embeddings = reducer.fit_transform(total_sample)

	# get a pool of indexes to randomly choose from
	indexes_pool = np.arange(embeddings.shape[0])

	# get empty arr to store the slices AKA the slice
	# to be used on the frontend of the latent garden
	embeddings_slices = np.empty((SLICE_SIZE, SLICE_SIZE, 4))

	# slices of latent vectors
	# to be used on the backend
	#latent_vectors_slices = np.empty((SLICE_SIZE, SLICE_SIZE, 1 + LATENT_VECTOR_SIZE))

	for slice_index in range(int(TOTAL_SAMPLE_SIZE/SLICE_SIZE)):
		# get random indexes from the pool 
	    indexes_selection = np.random.choice(indexes_pool, size=SLICE_SIZE, replace=False)
	    # What is position of the randomly chosen indexes in the indexes pool?
	    selected_indexes_positions = np.flatnonzero(np.isin(indexes_pool, indexes_selection))
	    # get embeddings at the randomly chosen indexes
	    embeddings_slice = embeddings[indexes_selection]
	    # append slice index column to the slice, to which slice does the slice belong to?
	    embeddings_slice = np.insert(embeddings_slice, 2, slice_index, 1)
	    # what is the id of each individual embedding?
	    embeddings_ids = np.arange(slice_index*SLICE_SIZE, slice_index*SLICE_SIZE+SLICE_SIZE)
	    # append the individual ids to the slice
	    embeddings_slice = np.insert(embeddings_slice, 3, embeddings_ids, 1)
	    # set the slice to the slices array
	    embeddings_slices[slice_index] = embeddings_slice
	    # delete used indexes from the pool so they're not used in next slices
	    indexes_pool = np.delete(indexes_pool, selected_indexes_positions)

	# flatten slices to a single column
	embeddings_slices = np.reshape(embeddings_slices, (TOTAL_SAMPLE_SIZE, 4))


# 	# save the embeddings
# 	csv_path = os.path.join(OUTPUT_PATH, CSV_FILENAME + ".csv")
# 	np.savetxt(csv_path, 
# 				embeddings, 
# 				delimiter=",", 
# 				header=CSV_HEADER, 
# 				comments=CSV_COMMENTS,				
# 				fmt=CSV_FMT) 
# 	print("Umap embeddings saved at: " + csv_path)	


if __name__ == '__main__':
    main()
