import numpy as np
import sys
import PIL
import os
import tensorflow as tf
import sle_gan

imShape = (256,256)
G_path = "./data/weights/metfaces_G-e388.h5"
latent_vectors_path = "./data/sky_watch_sample.csv"

def get_noise(batch_size: int):
    return np.random.normal(loc=0.0, scale=1.0, size=(batch_size,1,1,256))

def init_g():
    G_shape = (1, 1, 1, imShape[0])
    G = sle_ganq.Generator(imShape[0])
    G.build(G_shape)
    G.load_weights(G_path)
    return G

def generate_img(l_vec_idx):
    n = np.reshape(latent_vectors[l_vec_idx],(1,1,1,imShape[0]))
    generated_image = G(n)
    generated_image = generated_image.numpy()[0]
    generated_image = ((generated_image * 127.5) + 127.5).astype(np.uint8)
    # generated_image = generated_image.reshape(imShape)
    im = PIL.Image.fromarray(generated_image)
    im.save("./img.jpg", format="JPEG")

latent_vectors = np.genfromtxt(latent_vectors_path, delimiter=',')
print(latent_vectors[0])
# G = init_g()
# metadata_sock = init_sock_client()

# index = message[1]
# latent_vec_index = int(index)
# image = generate_img(latent_vec_index)
# imageByteSize = str(len(image))
# metadata = str(latent_vec_index) + metadata_msg_delimiter + imageByteSize + OF_tcp_stream_delimiter
# metadata = metadata.encode("utf-8")
# metadata_sock.sendall(metadata)
# gan_sock.sendall(image)


