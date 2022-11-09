extends Node

const HOST: String = "127.0.0.1"
const PORT: int = 5001
const RECONNECT_TIMEOUT: float = 3.0
const TEST_DATA = [1,2,3,4,5,6,7]


const Client = preload("res://Tcp_client.gd")
var _client: Client = Client.new()

func send_initial_data():
	var bytes : PoolByteArray = Arr.array_to_csv_string(TEST_DATA).to_utf8()
	_client.send(bytes)

func _ready() -> void:
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
	#send_initial_data()
#	var message = "hello server"
#	var bytes: PoolByteArray = message.to_utf8()
#	_client.send(bytes)

func _handle_client_data(data: PoolByteArray) -> void:
	var image : Image = Image.new()
	#print("Client data: ", data.get_string_from_utf8())
	var string_data: String = data.get_string_from_utf8()
	var decoded : PoolByteArray = Marshalls.base64_to_raw(string_data)
	image.load_jpg_from_buffer(decoded)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	
	var mat = SpatialMaterial.new()
	mat.albedo_texture = texture
	print("setting image")
	$Mesh.set_surface_material(0, mat)
	
	
	#var message: PoolByteArray = [97, 99, 107] # Bytes for "ack" in ASCII
	#_client.send(message)

func _handle_client_disconnected() -> void:
	print("Client disconnected from server.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds

func _handle_client_error() -> void:
	print("Client error.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds
