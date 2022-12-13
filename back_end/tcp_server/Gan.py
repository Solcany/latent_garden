import sle_gan
import constants
import numpy as np
from PIL import Image

class Gan:
    #def __init__(self):

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

    	# continue here, the images need to be encoded and joined together

    	#image = np.take(images, 0, 0).reshape((constants.IMAGE_SHAPE, constants.IMAGE_SHAPE))
    	#print(image.shape)
    	#images = images.reshape((3, constants.IMAGE_SHAPE, constants.IMAGE_SHAPE))
    	#print(images.shape)
    	#images = Image.fromarray(images[0,...])
    	#print(images)


    def generate_images_from_selection(self, selection_indices):
    	vectors_selection = np.take(self.vectors, selection_indices, 0)
    	images = self.generate_images(vectors_selection)
    	return images

	# spherical linear interpolation (slerp)
	def slerp(val, low, high):
		omega = np.arccos(np.clip(np.dot(low/np.linalg.norm(low), high/np.linalg.norm(high)), -1, 1))
		so = np.sin(omega)
		if so == 0:
			# L'Hopital's rule/LERP
			return (1.0-val) * low + val * high
		return np.sin((1.0-val)*omega) / so * low + np.sin(val*omega) / so * high


    def interpolate_vector_pair(self, v1, v2):


	# def generate_images(self, vectors):
	# 	n = np.reshape(latent_vectors[l_vec_idx],(1,1,1,imShape[0]))
	# 	generated_image = G(n)
	# 	generated_image = generated_image.numpy()[0]
	# 	generated_image = ((generated_image * 127.5) + 127.5).astype(np.uint8)
	# 	# generated_image = generated_image.reshape(imShape)
	# 	im = PIL.Image.fromarray(generated_image)
	# 	buffered = BytesIO()
	# 	im.save(buffered, format="JPEG")
	# 	image_bytes = base64.b64encode(buffered.getvalue())
	# 	return image_bytes

