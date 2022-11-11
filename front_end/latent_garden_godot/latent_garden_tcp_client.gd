extends Node

const HOST: String = "127.0.0.1"
const PORT: int = 5003
const RECONNECT_TIMEOUT: float = 3.0
const HEADER_START_DELIMITER : String = "***"
const MESSAGE_KEYVAL_DELIMITER : String = ":"
const MESSAGE_DATA_DELIMITER : String = ","
const MESSAGE_HEADER_END_DELIMITER : String = "&&&"
const DEBUG_SHOULD_CONNECT : bool = true
const REQUEST_IMAGES_METADATA : Dictionary = {"request": "requesting_images", "data_type": "int_array"}

const Client = preload("res://Tcp_client.gd")
var _client: Client = Client.new()

func compose_encoded_message(metadata: Dictionary, data : Array) -> String:
	var header : String = HEADER_START_DELIMITER
	
	var metadata_size : int = metadata.keys().size()
	var metadata_keys : Array = metadata.keys()
	
	for index in range(metadata_size):
		var key = metadata_keys[index]
		var value = str(metadata[key])
		if(index < metadata_size-1):
			header += "%s%s%s%s" % [key, 
									MESSAGE_KEYVAL_DELIMITER,
									value,
									MESSAGE_DATA_DELIMITER]
		else:
			header += "%s%s%s" % [key,
									MESSAGE_KEYVAL_DELIMITER,
									value]
	
	header += MESSAGE_HEADER_END_DELIMITER
	var body : String = Arr.array_to_csv_string(data)
	
	var message : String = header + body
	print(message)
	
	return message

func parse_client_data(client_data : String) -> Array:
	if(client_data.length() > 0  && client_data.begins_with(HEADER_START_DELIMITER)):
		# get the header substring
		var header_string : String = client_data.get_slice(MESSAGE_HEADER_END_DELIMITER, 0)
		# erase HEADER_START_DELIMITER from the header substring
		header_string.erase(header_string.find(HEADER_START_DELIMITER), HEADER_START_DELIMITER.length())
		# get key val pairs 
		var header_keyvals : PoolStringArray = header_string.split(MESSAGE_DATA_DELIMITER)
		var metadata = {}
		# parse key val pairs from the header
		for keyval in header_keyvals:
			var key = keyval.get_slice(MESSAGE_KEYVAL_DELIMITER, 0)
			var val = keyval.get_slice(MESSAGE_KEYVAL_DELIMITER, 1)
			metadata[key] = val
		
		# get the actual data of the message
		var data = client_data.get_slice(MESSAGE_HEADER_END_DELIMITER, 1)
		
		# is there any data in the message?
		if(data.length() > 0):
			return [metadata, data]
		# if the server sent only header...			
		else:
			push_warning("message contains only metadata")			
			return [metadata]
	else:
		push_warning("received client data is empty string or Header missing, returning empty array ")
		return []

func _on_request_images_from_gan_server(ids):
	var message : String = compose_encoded_message(REQUEST_IMAGES_METADATA, ids)
	var encoded : PoolByteArray = message.to_utf8()
	_client.send(encoded)
	
func _ready() -> void:
	if(DEBUG_SHOULD_CONNECT):
		_client.connect("connected", self, "_handle_client_connected")
		_client.connect("disconnected", self, "_handle_client_disconnected")
		_client.connect("error", self, "_handle_client_error")
		_client.connect("data", self, "_handle_client_data")
		add_child(_client)
		_client.connect_to_host(HOST, PORT)

func _connect_after_timeout(timeout: float) -> void:
	yield(get_tree().create_timer(timeout), "timeout") # Delay for timeout
	_client.connect_to_host(HOST, PORT)

func _handle_client_connected() -> void:
	print("Client connected to server.")

func _handle_client_data(raw_data: PoolByteArray) -> void:
	var string_data: String = raw_data.get_string_from_utf8()
	var parsed: Array = parse_client_data(string_data)
	var metadata : Dictionary = parsed[0]
	var data : String = parsed[1]

	var decoded : PoolByteArray = Marshalls.base64_to_raw(data)
	var image : Image = Image.new()
	image.load_jpg_from_buffer(decoded)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	var mat = SpatialMaterial.new()
	mat.albedo_texture = texture
	print("setting image")
	$Mesh.set_surface_material(0, mat)
	
func _handle_client_disconnected() -> void:
	print("Client disconnected from server.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds

func _handle_client_error() -> void:
	print("Client error.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds
