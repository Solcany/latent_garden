# import numpy as np
import socket
import base64
import sys
# import errno
from PIL import Image
import binascii
import os
import io
import codecs
# import tensorflow as tf
# import sle_gan

# imShape = (256,256)
HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
PORT = 5003 # Port to listen on (non-privileged ports are > 1023)
MESSAGE_START_TEXT = ">!<"
MESSAGE_PART_TEXT = ":::"
# G_path = "./data/weights/metfaces_G-e388.h5"
# latent_vectors_path = "./data/latent_vectors.csv"
# OF_tcp_stream_delimiter = "[/TCP]"
# metadata_msg_delimiter = "><"

# def get_noise(batch_size: int):
#     return np.random.normal(loc=0.0, scale=1.0, size=(batch_size,1,1,256))

# def init_g():
#     G_shape = (1, 1, 1, imShape[0])
#     G = sle_ganq.Generator(imShape[0])
#     G.build(G_shape)
#     G.load_weights(G_path)
#     return G

# def init_sock_client():
#     sock = socket.socket()
#     sock.connect((tcp_ip, tcp_port))
#     sock.setblocking(0)  
#     return sock

# def start_tcp_server():


# def generate_img(l_vec_idx):
#     n = np.reshape(latent_vectors[l_vec_idx],(1,1,1,imShape[0]))
#     generated_image = G(n)
#     generated_image = generated_image.numpy()[0]
#     generated_image = ((generated_image * 127.5) + 127.5).astype(np.uint8)
#     # generated_image = generated_image.reshape(imShape)
#     im = PIL.Image.fromarray(generated_image)
#     buffered = BytesIO()
#     im.save(buffered, format="JPEG")
#     image_bytes = base64.b64encode(buffered.getvalue())
#     return image_bytes

def image_to_bytes(image_path):
    #with open(image_path, "rb") as image_file:
        #txt = "metadata".encode("utf-8").hex()
        image = Image.open(image_path)
        buff = io.BytesIO()
        image.save(buff, format="JPEG")   

        header = "&!metadata:::".encode("utf-8")
        body = base64.b64encode(buff.getvalue())
        msg = header + body

        return msg
        #bts = 
        #print(test)
        #v = hex(ord('ô'))
        #v = bytes(hx, "utf-8")
        #txt = v.decode('utf-8')
        #print(txt)

       # print(bytes.fromhex(hx))

        #b = bytes.fromhex(hex_val)
        #print(b)
        #print(io.BytesIO(txt).getvalue())
        #txt = txt + image_file.read()
        #print(image_file.read())
        #b = base64.b64encode(image_file.read())
        # msg = txt + b
        # print(msg)
        #return b



    #image = Image.open(image_path)
    #buff = io.BytesIO()
    #image.save(buff, format="JPEG")
    #header = bytes("metadata blah blah:::::::::::::::::::", 'utf-8')
    #body = buff.getvalue()
    #wrapper = base64.b64encode(image)
    #message = header + body
    #print(wrapper.read())
    # print(wrapper)
    # print(message.decode())
    #image_bytes = base64.b64encode(message)
    #print(image_bytes.decode())
    #return image_bytes

def handle_data_received(data):
    data.decode().split(',')

def handle_on_client_connected(conn_socket):
    b = image_to_bytes("./data/image.jpg")
    conn_socket.sendall(b)

#def send_image():
    #


def main():
    b = image_to_bytes("./data/image.jpg")    
    # AF_INET is the Internet address family for IPv4
    # SOCK_STREAM is the socket type for TCP
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    while True:
        s.bind((HOST, PORT)) # associate the socket with particular network interface and port
        s.listen() # listen to incoming connections
        print("listening for connections")
        while True: 
            # this is a new socket used for communication with the client, different from the listening socket
            conn, addr = s.accept() # block execution, wait for a connection, on connections returns connection socket object and the address
            print(f"Connected by {addr}")
            while True:
                handle_on_client_connected(conn)
                data = conn.recv(1024) # recv blocks execution and reads data from the client
                # receiving empty bytes b'' signals the client is closing the connection and while loop is exited
                # The bufsize argument of 1024 used above is the maximum amount of data to be received at once.
                if len(data) == 0: 
                    break
                else:
                    handle_data_received(data)
                # if not data:
                #     break
                #conn.sendall(data) 
                # sendall sends received data back to client
                # Unlike send(), sendall continues to send data from bytes until either all data has been sent or an error occurs. None is returned on success.

    #latent_vectors = np.genfromtxt(latent_vectors_path, delimiter=',')

    # G = init_g()
    # metadata_sock = init_sock_client()
    # gan_sock = init_sock_client()


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

if __name__ == '__main__':
    main()


