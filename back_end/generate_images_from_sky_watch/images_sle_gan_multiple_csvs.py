if __name__ == '__main__':
    main()

import numpy as np
import tensorflow as tf
import sle_gan
from pathlib import Path
import re
import glob
import PIL

GENERATOR_WEIGHTS_PATH = "./data/weights/metfaces_G-e388.h5"
GLOB_INPUT_DATA_PATH = '/users/m/documents/_DIGITAL/rust/sky_watch/process_sky_images_to_tiles/data/output/friday_tiles/csv/*.csv'
OUTPUT_PATH = './output/friday_images'
IM_SHAPE = (256,256)

def init_generator():
    generator_shape = (1, 1, 1, IM_SHAPE[0])
    generator = sle_gan.Generator(IM_SHAPE[0])
    generator.build(generator_shape)
    generator.load_weights(GENERATOR_WEIGHTS_PATH)
    return generator

def get_noise(batch_size: int):
    return np.random.normal(loc=0.0, scale=1.0, size=(batch_size,1,1,IM_SHAPE[0]))    

def generate_image(generator, latent_point):
    p = np.reshape(latent_point,(1,1,1,IM_SHAPE[0]))
    generated_image = generator(p)
    generated_image = generated_image.numpy()[0]
    generated_image = ((generated_image * 127.5) + 127.5).astype(np.uint8)
    return PIL.Image.fromarray(generated_image)

def main():
    # get the csv data
    csv_paths = sorted(glob.glob(GLOB_INPUT_DATA_PATH), key=lambda path: int(re.search(r'\d+', path).group()))

    # create the output dir
    Path(OUTPUT_PATH).mkdir(parents=True, exist_ok=True)

    # init the generator
    generator = init_generator()

    for csv_index, csv_path in enumerate(csv_paths):
        print("working on csv-" + str(csv_index))
        dir_path = OUTPUT_PATH + "/" + str(csv_index)
        # create dir for the images
        Path(dir_path).mkdir(parents=True, exist_ok=True)
        # load the csv
        latent_points = np.genfromtxt(csv_path, delimiter=',')

        # generate images and save them
        for point_index, point in enumerate(latent_points):
            image = generate_image(generator, point)
            image_output_path = dir_path + "/" + str(point_index) + ".jpg"
            image.save(image_output_path, format="JPEG")









