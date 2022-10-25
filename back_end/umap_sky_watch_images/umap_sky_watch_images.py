import numpy as np 
import glob
import PIL
import os 
import umap
import numpy as np

input_path = "/users/m/documents/__PROJECTS/2022/latent_garden_app/latent_garden/back_end/generate_images_from_sky_watch/output/friday_images/"
input_image_format = "jpg"
umap_neighbours = 50
umap_min_distatnce = 0.1
umap_dimensions = 3
output_path = "./output/"
csv_filename = "images_embeddings"
csv_header = "tile_index, x, y, z"
csv_comments = "" # should the csv header have any text before the labels? (like '#' for python comment)
csv_fmt = "%f" #fmt "%f" ensures floats are not saved in the sci annotation format to to the csv file


def main():
	# create output folder
	if not os.path.isdir(output_path):
	    os.mkdir(output_path)

	# get all folders containing images
	path = os.path.join(input_path, "*")
	input_folders = glob.glob(path)

	all_images = []
	input_folders_sizes = []

	# load images from all folders into a list
	for folder_index, folder in enumerate(input_folders):
		# get all image paths
		images_paths = glob.glob( os.path.join(folder, "*." + input_image_format ))
		images_paths.sort(key=lambda f: int(''.join(filter(str.isdigit, f))))
		print("Loading " + str(len(images_paths)) + " images in folder: " + str(folder_index+1) + "/" + str(len(input_folders)))
		for path in images_paths:
			# convert PIL Image to numpy array
			image = np.asarray(PIL.Image.open(path))
			# merge r,g,b values into a single array
			image = np.reshape(image, (image.shape[0] * image.shape[1] * image.shape[2]))
			all_images.append(image)
		# store the amount of images in each folder
		input_folders_sizes.append(len(images_paths))
	# convert list to numpy array
	all_images = np.asarray(all_images)
	print("Running umap")	
	# get embeddings
	reducer = umap.UMAP(n_neighbors=umap_neighbours, min_dist=umap_min_distatnce, n_components=umap_dimensions)
	embeddings = reducer.fit_transform(all_images)
	# create a new column to store the folder's index in the output data
	embeddings = np.insert(embeddings, 0, 0, 1)

	# assign folder index to each embedding
	image_index = 0
	for folder_index, folder_size in enumerate(input_folders_sizes):
		for _ in range(folder_size):
			embeddings[image_index][0] = folder_index
			image_index += 1

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
