import numpy as np
import sys
import PIL
import os
import tensorflow as tf
import sle_gan

imShape = (256,256)
G_path = "./data/weights/metfaces_G-e388.h5"
latent_vectors_path = "./data/sky_watch_sample_only_positive.csv"

def get_noise(batch_size: int):
    return np.random.normal(loc=0.0, scale=1.0, size=(batch_size,1,1,256))

def init_g():
    G_shape = (1, 1, 1, imShape[0])
    G = sle_gan.Generator(imShape[0])
    G.build(G_shape)
    G.load_weights(G_path)
    return G

def generate_save_img(G, vec, idx):
    n = np.reshape(vec,(1,1,1,imShape[0]))
    generated_image = G(n)
    generated_image = generated_image.numpy()[0]
    generated_image = ((generated_image * 127.5) + 127.5).astype(np.uint8)
    # generated_image = generated_image.reshape(imShape)
    im = PIL.Image.fromarray(generated_image)
    im_path = "./output/img" + str(idx) + ".jpg"
    im.save(im_path, format="JPEG")

latent_vectors = np.genfromtxt(latent_vectors_path, delimiter=',')

G = init_g()
for idx, vec in enumerate(latent_vectors): 
    generate_save_img(G, vec, idx)


