import constants
import socket
import warnings
#import sys

class Tcp_server:
    def __init__(self, callbacks):
        self.status = constants.SERVER_STATUS_OFFLINE
        self.callbacks = callbacks
        self.connection = None
        self.connection_address = None

    def parse_message(self, message):
        # parses decoded string message into metadata and data 

        # Does the message have any data?
        assert len(message) > 0

        # Is the message complete?     
        assert message.startswith(constants.MESSAGE_HEADER_START_DELIMITER)

        # split the message into header and body
        header_string, body_string = message.split(constants.MESSAGE_HEADER_END_DELIMITER)
        # remove the string delimiting the beginning of the message
        metadata_string = header_string.replace(constants.MESSAGE_HEADER_START_DELIMITER, '')
        # split the header into metadata key value pairs
        metadata_keyvals = metadata_string.split(constants.MESSAGE_DATA_DELIMITER)
        # key value pairs into dict
        metadata = {}
        for keyval in metadata_keyvals:
            key, val = keyval.split(constants.MESSAGE_KEYVAL_DELIMITER)
            metadata[key] = val

        # Does the message have the request key?   
        assert constants.MESSAGE_REQUEST_KEY in metadata     

        # is there any data in the body?
        if(len(body_string) > 0):           
            # does the received message have the data type key?
            assert constants.MESSAGE_DATA_TYPE_KEY in metadata
            # is the data type supported?
            assert metadata[constants.MESSAGE_DATA_TYPE_KEY] in constants.MESSAGE_SUPPORTED_DATA_TYPES

            data = []
            # process the body of the message
            # treat different data types accordingly...
            if(metadata[constants.MESSAGE_DATA_TYPE_KEY] == "int_array"):
                data = body_string.split(constants.MESSAGE_ARR_DATA_DELIMITER)
                data = list(map(lambda v: int(v), data))
            elif(metadata[constants.MESSAGE_DATA_TYPE_KEY] == "float_array"):
                data = body_string.split(constants.MESSAGE_ARR_DATA_DELIMITER)
                data = list(map(lambda v: float(v), data))
            return [metadata, data]
        else:
            warnings.warn("the message has no body, returning metadata only")
            return [metadata]

    def send_to_client(self, message):
        if(self.connection and self.status == constants.SERVER_STATUS_ONLINE_WITH_CLIENT):
            # Unlike send(), sendall continues to send data from bytes until either all data has been sent or an error occurs. None is returned on success.
            self.connection.sendall(message)                

    def handle_message_received(self, message):
        decoded = message.decode("utf-8")
        parsed_data = self.parse_message(decoded)
        metadata = parsed_data[0]

        callback_name = "on_" + metadata[constants.MESSAGE_REQUEST_KEY]
        self.callbacks[callback_name](parsed_data)

    def handle_server_started(self):
        self.status = constants.SERVER_STATUS_ONLINE
        print("Server listening for connections")

    def handle_on_client_connected(self, connection, address):
        self.status = constants.SERVER_STATUS_ONLINE_WITH_CLIENT        
        self.connection = connection
        self.connection_address = address
        print("Client connected at: {}".format(address))

    def start(self):
        if True:
            # AF_INET is the Internet address family for IPv4
            # SOCK_STREAM is the socket type for TCP
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            # s.setblocking(0)  
            while True:
                s.bind((constants.HOST, constants.PORT)) # associate the socket with particular network interface and port
                s.listen() # listen to incoming connections
                self.handle_server_started()
                while True: 
                    # this is a new socket used for communication with the client, different from the listening socket
                    connection, address = s.accept() # block execution, wait for a connection, on connections returns connection socket object and the address
                    self.handle_on_client_connected(connection, address)
                    while True:
                        # recv blocks execution and reads data from the client
                        # receiving empty bytes b'' signals the client is closing the connection and while loop is exited
                        # The bufsize argument of 1024 used above is the maximum amount of data to be received at once.                        
                        message = self.connection.recv(1024) 
                        if len(message) == 0: 
                            warnings.warn("Received empty message")
                            break
                        else:
                            self.handle_message_received(message)

# def get_noise(batch_size: int):
#     return np.random.normal(loc=0.0, scale=1.0, size=(batch_size,1,1,256))

    # while True:
    #     try:
    #         message = gan_sock.recv(1024)
    #         message = message.decode()
    #         message = message.replace('[/TCP]\x00','')
    #         message = message.split(":")
    #         command = message[0]
    #         if(command == "getImage"):
    #             index = message[1]
    #             latent_vec_index = int(index)
    #             image = generate_img(latent_vec_index)
    #             imageByteSize = str(len(image))
    #             metadata = str(latent_vec_index) + metadata_msg_delimiter + imageByteSize + OF_tcp_stream_delimiter
    #             metadata = metadata.encode("utf-8")
    #             metadata_sock.sendall(metadata)
    #             gan_sock.sendall(image)
    #         elif(command =="exitApp"):
    #             print("exiting app")
    #             sys.exit(1)
    #     except socket.error as e:
    #         err = e.args[0]
    #         if err == errno.EAGAIN or err == errno.EWOULDBLOCK:
    #             continue
    #         else:
    #             # a "real" error occurred
    #             print(e)
    #             sys.exit(1)


