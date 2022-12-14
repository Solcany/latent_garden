from Tcp_server import Tcp_server
from Gan import Gan
from utils import convert_value_to_string
import constants
from io import BytesIO
from base64 import b64encode
from PIL import Image


def get_encoded_generated_images(images):
	encoded = "".encode("utf-8")
	delimiter = constants.MESSAGE_DATA_DELIMITER.encode("utf-8")
	for index, image in enumerate(images):
		buff = BytesIO()
		image.save(buff, format="JPEG")
		image_bytes = b64encode(buff.getvalue())
		if(index < len(images)-1):
			encoded += image_bytes + delimiter
		# don't add the MESSAGE_DATA_DELIMITER after the last image
		else:
			encoded += image_bytes
	return encoded

def get_encoded_message_header(metadata):
    header = constants.MESSAGE_HEADER_START_DELIMITER
    for index, key in enumerate(metadata):
        value = convert_value_to_string(metadata[key])
        if(index < len(metadata)-1):
            header += "{}{}{}{}".format(key, 
                                        constants.MESSAGE_KEYVAL_DELIMITER, 
                                        value, 
                                        constants.MESSAGE_DATA_DELIMITER)
        # avoid adding the MESSAGE_DATA_DELIMITER for the last item
        else:
            header += "{}{}{}".format(key, 
                                        constants.MESSAGE_KEYVAL_DELIMITER, 
                                        value)            
    header += constants.MESSAGE_HEADER_END_DELIMITER
    header = header.encode("utf-8")
    return header

def get_images_message(metadata, images):
    header = get_encoded_message_header_bytes(metadata)
    data = get_encoded_generated_images(images)
    message = header + data
    return message

def on_generate_images(request_data):
		metadata, latent_vectors_indices = request_data
		images = gan.generate_images_from_selection(latent_vectors_indices)
		response_metadata ={"response": "images", 
							"data_type": "b64_images",
							"indices": latent_vectors_indices}
		header = get_encoded_message_header(response_metadata)
		body = get_encoded_generated_images(images)
		message = header + body
		tcp_server.send_to_client(message)
		print("generated images sent to the client")

def on_generate_slerped_images(request_data):
		metadata, latent_vectors_indices = request_data
		print(metadata)
		images = gan.generate_images_from_slerped_selection(latent_vectors_indices, int(metadata["slerp_steps"]))
		response_metadata ={"response": "slerped_images", 
							"data_type": "b64_images",
							"indices": latent_vectors_indices}		
		header = get_encoded_message_header(response_metadata)
		body = get_encoded_generated_images(images)
		message = header + body
		tcp_server.send_to_client(message)

# need these in the global scope 
gan = Gan()
tcp_server = Tcp_server(callbacks={"on_generate_images": on_generate_images,
									"on_generate_slerped_images": on_generate_slerped_images})

def main():
	gan.init_sle_gan()
	tcp_server.start()

if __name__ == '__main__':
    main()