from Tcp_server import Tcp_server


def main():
	tcp_server = Tcp_server(1)
	tcp_server.start()
	#tcp_server.parse_received_message("***request:get_images,data_type:int_array&&&7,8,59,63,117,143,162,181,182,195,214,215,222")


if __name__ == '__main__':
    main()