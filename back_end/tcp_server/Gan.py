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

	def create_new_ids(self, n_ids):
		# new ids are created at the end of the list of the existing ones
		last_id = self.ids[-1]
		new_ids = np.arange(last_id + 1, last_id + n_ids + 1)
		return new_ids

	def update_all_ids(self, new_ids):
		self.ids = np.append(self.ids, new_ids)

	def get_lerped_ids(self, existing_ids, slerp_steps):
		# create ids for dynamically generated lerped latent points
		# for each existing latent point ID create slerp_steps amount of new ids

		# where should be the new set of ids inserted in the list of the existing ids
		insert_index = 1
		# for each existing id (except the last one) create a list of new ids
		ids = np.array(existing_ids, copy=True)
		for index in existing_ids[:len(existing_ids)-1]:
			new_ids = self.create_new_ids(slerp_steps)
			# intersperse the new ids with the existing ones
			ids = np.insert(ids, insert_index, new_ids)
			# move the insertion index forward
			insert_index = insert_index + slerp_steps + 1
			self.update_all_ids(new_ids)

		return ids

	def generate_images_from_slerped_selection(self, selection_indices, slerp_steps):
		vectors_selection = np.take(self.vectors, selection_indices, 0)
		slerped_vectors = slerp_list(vectors_selection, slerp_steps)					
		slerped_vectors = np.reshape(slerped_vectors, constants.SLE_GAN_VECTOR_SHAPE)			
		ids = self.get_lerped_ids(selection_indices, slerp_steps)
		images = self.generate_images(slerped_vectors)
		return (images, ids)
