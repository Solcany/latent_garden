import numpy as np 
import glob
import PIL
import os 
import umap
import numpy as np

umap_neighbours = 50
umap_min_distance = 0.1
umap_dimensions = 2
output_path = "./output/"
csv_filename = "random_nums_3d_embeddings"
csv_header = "x, y, z"
csv_comments = "" # should the csv header have any text before the labels? (like '#' for python comment)
csv_fmt = "%f" #fmt "%f" ensures floats are not saved in the sci annotation format to to the csv file


def main():
	# create output folder
	if not os.path.isdir(output_path):
	    os.mkdir(output_path)

	numbers = np.random.normal(0, 1, (300, 128))

	print("Running umap")	
	# get embeddings
	reducer = umap.UMAP(n_neighbors=umap_neighbours, min_dist=umap_min_distance, n_components=umap_dimensions)
	embeddings = reducer.fit_transform(numbers)

	# create 3rd column for z index, where z is always 0
	embeddings = np.insert(embeddings, 2, 0, 1)


	# save the embeddings
	csv_path = os.path.join(output_path, csv_filename + ".csv")
	np.savetxt(csv_path, 
				embeddings, 
				delimiter=",", 
				header=csv_header, 
				comments=csv_comments,				
				fmt=csv_fmt) 
	print("Umap embeddings saved at: " + csv_path)	


if __name__ == '__main__':
    main()
