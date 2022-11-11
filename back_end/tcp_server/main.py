from Tcp_server import Tcp_server
from Gan import Gan

def on_requesting_images(data):
	print("images requested!")
	print(data)


def main():
	callbacks = {"on_requesting_images": on_requesting_images}
	tcp_server = Tcp_server(callbacks)
	tcp_server.start()

	gan = Gan()
	


if __name__ == '__main__':
    main()