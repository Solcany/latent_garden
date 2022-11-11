from Tcp_server import Tcp_server
from Gan import Gan
import io
import base64
from PIL import Image

def on_requesting_images(data):
	print("images requested!")
	print(data)


def main():
	# callbacks = {"on_requesting_images": on_requesting_images}
	# tcp_server = Tcp_server(callbacks)
	# tcp_server.start()

	gan = Gan()
	gan.init_sle_gan()
	gan.generate_images_from_selection([1,2,3])



if __name__ == '__main__':
    main()