import sle_gan
import constants
from slerp import lerp_list, slerp_list
import numpy as np
from PIL import Image

class Gan:
	def init_sle_gan(self):
		csv = np.genfromtxt(constants.LATENT_VECTORS_PATH, delimiter=',', skip_header=constants.LATENT_VECTORS_SKIP_HEADER)
		ids = csv[:,0]
		vectors = csv[:,1:]
		self.ids = np.array(ids)
		self.vectors = vectors
		self.generator = sle_gan.Generator(constants.IMAGE_SHAPE)
		self.generator.build((1, 1, 1, constants.IMAGE_SHAPE))
		self.generator.load_weights(constants.GAN_WEIGHTS_PATH)

	def get_new_ids(self, n_ids):
		last_id = self.ids[-1]
		new_ids = np.arange(last_id + 1, last_id + n_ids + 1)
		return new_ids

	def generate_images(self, vectors):
		images = self.generator(vectors)
		images = images.numpy()
		images = ((images * 127.5) + 127.5).astype(np.uint8)
		pil_images = []

		for image in images:
			pil_image = Image.fromarray(image)
			pil_images.append(pil_image)
		return pil_images

	def generate_images_from_selection(self, selection_indices):
		vectors_selection = np.take(self.vectors, selection_indices, 0)
		vectors_selection = np.reshape(vectors_selection, constants.SLE_GAN_VECTOR_SHAPE)	
		images = self.generate_images(vectors_selection)
		return images

	def get_slerped_ids(self, selection_indices, slerp_steps):

		# continue here :)
		
		new_ids = np.array(selection_indices)
		insert_index = 1
		for index in selection_indices[:len(selection_indices)-1]:
			ids_segment = self.get_new_ids(slerp_steps)
			self.ids = np.append(self.ids, ids_segment)
			new_ids = np.insert(new_ids, insert_index, ids_segment)
			insert_index = insert_index + slerp_steps + 1
		print(new_ids)

	def generate_images_from_slerped_selection(self, selection_indices, slerp_steps):
		vectors_selection = np.take(self.vectors, selection_indices, 0)
		slerped_vectors = slerp_list(vectors_selection, slerp_steps)					
		slerped_vectors = np.reshape(slerped_vectors, constants.SLE_GAN_VECTOR_SHAPE)			
		print("slerrpppp!")
		self.get_slerped_ids(selection_indices, 3)
		images = self.generate_images(slerped_vectors)
		return images
