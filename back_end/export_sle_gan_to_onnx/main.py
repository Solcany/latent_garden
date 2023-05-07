import sle_gan
import tensorflow as tf
import tf2onnx
import onnx

GAN_WEIGHTS_PATH = "./data/gan/metfaces_G-e388.h5"
IMAGE_SHAPE = 256
MODEL_OUT_PATH = "./data/export/metfaces_sle_gan.onnx"

def main():
	gan = sle_gan.Generator(IMAGE_SHAPE)
	gan.build((1, 1, 1, IMAGE_SHAPE))
	gan.load_weights(GAN_WEIGHTS_PATH)
	input_signature = [tf.TensorSpec([1, 1, 1, IMAGE_SHAPE], tf.float32, name='x')]
	onnx_model, _ = tf2onnx.convert.from_keras(gan, input_signature, opset=13)
	onnx.save(onnx_model, MODEL_OUT_PATH)
	
if __name__ == '__main__':
    main()