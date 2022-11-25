import numpy as np 
import glob
import os 
import umap
import numpy as np

TOTAL_SAMPLE_SIZE = 1000
SLICE_SIZE = 100
SLICES_N = int(TOTAL_SAMPLE_SIZE / SLICE_SIZE)
LATENT_VECTOR_SIZE = 256
UMAP_NEIGHBOURS = 50
UMAP_MIN_DISTATNCE = 0.1
UMAP_DIMENSIONS = 2
OUTPUT_PATH = "./output/"
FRONT_END_CSV_FILENAME = "frontend_2d_embeddings_slices"
FRONT_END_CSV_HEADER = "id,slice_id,x,y,z"
FRONT_END_CSV_COLUMNS = 5 # id, slice_id, x, y, z
BACK_END_CSV_FILENAME = "backend_latent_vectors_slices"
BACK_END_CSV_HEADER = "id,{}".format(','.join([str(x) for x in range(LATENT_VECTOR_SIZE)]))
BACK_END_CSV_COLUMNS = LATENT_VECTOR_SIZE + 1 
CSV_COMMENTS = "" # should the csv header have any text before the labels? (like '#' for python comment)
CSV_FMT = "%f" #fmt "%f" ensures floats are not saved in the sci annotation format to to the csv file


def main():
	assert(TOTAL_SAMPLE_SIZE % SLICE_SIZE == 0)
	# get a sample of random numbers
	total_sample = np.random.normal(0, 1, (TOTAL_SAMPLE_SIZE, LATENT_VECTOR_SIZE))
	print("Running umap")	
	# reduce the dimensions of the sample to UMAP_DIMENSIONS dimensions
	reducer = umap.UMAP(n_neighbors=UMAP_NEIGHBOURS, min_dist=UMAP_MIN_DISTATNCE, n_components=UMAP_DIMENSIONS)
	embeddings = reducer.fit_transform(total_sample)

	# get a pool of indexes to randomly choose from for each slice
	indexes_pool = np.arange(embeddings.shape[0])

	# get empty arr to store the slices AKA the slice
	# to be used on the frontend of the latent garden app
	embeddings_slices = np.zeros((SLICES_N, SLICE_SIZE, FRONT_END_CSV_COLUMNS)) # x, y, slice id, vector id

	# slices of latent vectors
	# to be used on the backend
	latent_vectors_slices = np.zeros((SLICES_N, SLICE_SIZE, BACK_END_CSV_COLUMNS)) # id, LATENT_VECTOR_SIZE vector

	for slice_index in range(SLICES_N):
		# get random indexes from the pool 
		indexes_selection = np.random.choice(indexes_pool, size=SLICE_SIZE, replace=False)
		# What is position of the randomly chosen indexes in the indexes pool?
		selected_indexes_positions = np.flatnonzero(np.isin(indexes_pool, indexes_selection))
		# what is the id of each individual embedding and latent vector?
		first_id = slice_index * SLICE_SIZE
		last_id = first_id + SLICE_SIZE
		ids = np.arange(first_id, last_id)
		# append the individual ids to the slice
		embeddings_slices[slice_index, :, 0] = ids
		# append slice index column to the slice, to which slice does the slice belong to?
		embeddings_slices[slice_index, :, 1] = slice_index				
		# get randomly selected x,y embeddings 
		embeddings_slices[slice_index, :, 2:4] = embeddings[indexes_selection]
		# manually set z coordinate to be 0
		embeddings_slices[slice_index, :, 4] = 0

		# set the slice to the slices array
		# get latent vectors
		latent_vectors_slices[slice_index, :, 0] = ids
		latent_vectors_slices[slice_index, :, 1:BACK_END_CSV_COLUMNS] = total_sample[indexes_selection]
		# delete used indexes from the pool so they're not used in next slices
		indexes_pool = np.delete(indexes_pool, selected_indexes_positions)

	# flatten slices to a single column
	embeddings_slices = np.reshape(embeddings_slices, (TOTAL_SAMPLE_SIZE, FRONT_END_CSV_COLUMNS))
	latent_vectors_slices = np.reshape(latent_vectors_slices, (TOTAL_SAMPLE_SIZE, BACK_END_CSV_COLUMNS))

	# save the embeddings
	# create output folder
	if not os.path.isdir(OUTPUT_PATH):
	    os.mkdir(OUTPUT_PATH)

	frontend_csv_path = os.path.join(OUTPUT_PATH, FRONT_END_CSV_FILENAME + ".csv")
	np.savetxt(frontend_csv_path, 
				embeddings_slices, 
				delimiter=",", 
				header=FRONT_END_CSV_HEADER, 
				comments=CSV_COMMENTS,				
				fmt=CSV_FMT)
	print("frontend data saved at: " + frontend_csv_path)	

	backend_csv_path = os.path.join(OUTPUT_PATH, BACK_END_CSV_FILENAME + ".csv")
	np.savetxt(backend_csv_path, 
				latent_vectors_slices, 
				delimiter=",", 
				header=BACK_END_CSV_HEADER, 
				comments=CSV_COMMENTS,		
				fmt=CSV_FMT
				) 

	print("backend data saved at: " + backend_csv_path)	


if __name__ == '__main__':
    main()
