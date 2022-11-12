extends Reference


class_name Encode_utils

static func decode_b64_image_string(b64_image_data : String) -> Image:
	var decoded : PoolByteArray = Marshalls.base64_to_raw(b64_image_data)
	var image : Image = Image.new()
	image.load_jpg_from_buffer(decoded)
	return image
