import sle_gan
import constants
import numpy as np
from PIL import Image

class Gan:
	# spherical linear interpolation (slerp)
	def slerp(self, val, low, high):
		omega = np.arccos(np.clip(np.dot(low/np.linalg.norm(low), high/np.linalg.norm(high)), -1, 1))
		so = np.sin(omega)
		if so == 0:
			# L'Hopital's rule/LERP
			return (1.0-val) * low + val * high
		return np.sin((1.0-val)*omega) / so * low + np.sin(val*omega) / so * high

	def slerp_list(self, vectors, steps):
		slerped_vectors = []
		ratios = np.linspace(0, 1, num=steps)
		# remove the last ratio = 1.0 to avoid duplicate vectors
		ratios = ratios[:len(ratios)-1]
		for idx in range(len(vectors)-1):
			vec1 = vectors[idx]
			vec2 = vectors[idx+1]
			for ratio in ratios:
				new_vec = self.slerp(ratio, vec1, vec2)
				slerped_vectors.append(new_vec)
		# add the very last point
		slerped_vectors.append(vectors[-1])
		return slerped_vectors

	def init_sle_gan(self):
		csv = np.genfromtxt(constants.LATENT_VECTORS_PATH, delimiter=',', skip_header=constants.LATENT_VECTORS_SKIP_HEADER)
		ids = csv[:,0]
		vectors = csv[:,1:]
		vectors = np.reshape(vectors, constants.SLE_GAN_VECTOR_SHAPE)
		print(vectors.shape)
		self.ids = ids # WIP: this isn't used for now, is it needed?
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
		images = self.generate_images(vectors_selection)
		return images

	def generate_images_from_slerped_selection(self, selection_indices, slerp_steps):
		vectors_selection = np.take(self.vectors, selection_indices, 0)
		slerped_vectors = self.slerp_list(vectors_selection, slerp_steps)
		images = self.generate_images(slerped_vectors)
