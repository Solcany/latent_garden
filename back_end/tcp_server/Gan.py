import sle_gan
#import numpy as np
#from PIL import Image

class Gan:
    def __init__(self):
    	self.G = sle_gan.Generator(constants.IMAGE_SHAPE)
    	self.G.build((1, 1, 1, constants.IMAGE_SHAPE[0]))
    	self.G.load_weights(constants.GAN_WEIGHTS_PATH)
    	print("Gan initiated")
