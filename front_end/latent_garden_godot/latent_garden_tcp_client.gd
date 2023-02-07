extends Node
const Client = preload("res://Tcp_client.gd")
var _client: Client = Client.new()
signal server_response_images_returned
signal server_response_slerped_images_returned

func compose_encoded_message(metadata: Dictionary, data : Array) -> String:
	var header : String = Constants.MESSAGE_HEADER_START_DELIMITER
	
	var metadata_size : int = metadata.keys().size()
	var metadata_keys : Array = metadata.keys()
	
	for index in range(metadata_size):
		var key = metadata_keys[index]
		var value = str(metadata[key])
		if(index < metadata_size-1):
			header += "%s%s%s%s" % [key, 
									Constants.MESSAGE_KEYVAL_DELIMITER,
									value,
									Constants.MESSAGE_DATA_DELIMITER]
		else:
			header += "%s%s%s" % [key,
									Constants.MESSAGE_KEYVAL_DELIMITER,
									value]
	
	header += Constants.MESSAGE_HEADER_END_DELIMITER
	var body : String = Utils.array_to_string(data, Constants.MESSAGE_ARR_DATA_DELIMITER)
	
	var message : String = header + body
	
	return message

func parse_client_data(client_data : String) -> Array:
	if(client_data.length() > 0  && client_data.begins_with(Constants.MESSAGE_HEADER_START_DELIMITER)):
		# get the header substring
		var header_string : String = client_data.get_slice(Constants.MESSAGE_HEADER_END_DELIMITER, 0)
		# erase HEADER_START_DELIMITER from the header substring
		header_string.erase(header_string.find(Constants.MESSAGE_HEADER_START_DELIMITER), Constants.MESSAGE_HEADER_START_DELIMITER.length())
		# get key val pairs 
		var header_keyvals : PoolStringArray = header_string.split(Constants.MESSAGE_DATA_DELIMITER)
		var metadata = {}
		# parse key val pairs from the header
		for keyval in header_keyvals:
			var key = keyval.get_slice(Constants.MESSAGE_KEYVAL_DELIMITER, 0)
			var val = keyval.get_slice(Constants.MESSAGE_KEYVAL_DELIMITER, 1)
			metadata[key] = val
			
		# continue parsing metadata based on the request kind of the client_data
		if(metadata.response == "images" or metadata.response == "slerped_images"):
			# convert indices from strings to ints
			metadata.indices = Utils.string_array_to_num_array(Utils.string_to_array(metadata.indices, Constants.MESSAGE_ARR_DATA_DELIMITER), "int")
			if(metadata.response == "slerped_images"):
				metadata.slerped_indices = Utils.string_array_to_num_array(Utils.string_to_array(metadata.slerped_indices, Constants.MESSAGE_ARR_DATA_DELIMITER), "int")
				metadata.slerp_steps = int(metadata.slerp_steps)
			var images_string_data : String =  client_data.get_slice(Constants.MESSAGE_HEADER_END_DELIMITER, 1)
			var image_data : PoolStringArray = []
			# is there a single image or multiple?
			# occurence of MESSAGE_DATA_DELIMITER suggests there's multiple images
			if( images_string_data.find(Constants.MESSAGE_DATA_DELIMITER) > 0):
				image_data = images_string_data.split(Constants.MESSAGE_DATA_DELIMITER)
				return [metadata, image_data]
			# otherwise it's a single image
			else:
				image_data = [images_string_data]
				return [metadata, image_data] 
		else: 
			push_error ("the response type is unknown or the reponse value in metadata is missing")
			return []
	else:
		push_error("received client data is empty string or the data is incomplete")
		return []

func _on_request_generate_images(ids):
	var message : String = compose_encoded_message(Constants.REQUEST_GENERATE_IMAGES_METADATA, ids)
	var encoded : PoolByteArray = message.to_utf8()
	_client.send(encoded)
	
func _on_request_generate_slerped_images(ids):
	var message : String = compose_encoded_message(Constants.REQUEST_GENERATE_SLERPED_IMAGES_METADATA, ids)
	var encoded : PoolByteArray = message.to_utf8()
	_client.send(encoded)
		
func _ready() -> void:
	_client.connect("connected", self, "_handle_client_connected")
	_client.connect("disconnected", self, "_handle_client_disconnected")
	_client.connect("error", self, "_handle_client_error")
	_client.connect("data", self, "_handle_client_data")
	add_child(_client)
	_client.connect_to_host(Constants.HOST_IP, Constants.HOST_PORT)
	
	# connect server response signals to the events bus
	connect("server_response_images_returned", get_node("/root/App/"), "_on_server_response_images_returned")
	connect("server_response_slerped_images_returned", get_node("/root/App/"), "_on_server_response_slerped_images_returned")
	
func _connect_after_timeout(timeout: float) -> void:
	yield(get_tree().create_timer(timeout), "timeout") # Delay for timeout
	_client.connect_to_host(Constants.HOST_IP, Constants.HOST_PORT)

func _handle_client_connected() -> void:
	print("Client connected to server.")

func _handle_client_data(raw_data: PoolByteArray) -> void:
	var string_data: String = raw_data.get_string_from_utf8()
	var parsed: Array = parse_client_data(string_data)
	var metadata : Dictionary = parsed[0]
	var data : PoolStringArray = parsed[1]
	
	if (metadata.response == "images"):
		emit_signal("server_response_images_returned", [metadata, data])
	elif (metadata.response == "slerped_images"):
		emit_signal("server_response_slerped_images_returned", [metadata, data])		
	else:
		push_error ("the response type is unknown or the reponse value in metadata is missing")
	
	
func _handle_client_disconnected() -> void:
	print("Client disconnected from server.")
	_connect_after_timeout(Constants.HOST_RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds

func _handle_client_error() -> void:
	print("Client error.")
	_connect_after_timeout(Constants.HOST_RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds
