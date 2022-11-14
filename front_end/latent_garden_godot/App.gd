extends Spatial

signal get_selected_latent_nodes
signal request_images_from_server
signal return_images

func _on_submit_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes")
	
# when the Nodes container returns selected latent nodes
func _on_return_selected_latent_nodes_ids(ids) -> void:
	emit_signal("request_images_from_server", ids)
	
# when the tcp client receives images from the server
func _on_server_response_images_returned(data) -> void:
	emit_signal("return_images", data)
	

func _ready():
	# query currently selected latent nodes from the Nodes container
	connect("get_selected_latent_nodes", get_node("Nodes/Nodes_container"), "_on_get_selected_latent_nodes")

	# pass image data to the Nodes container
	connect("return_images", get_node("Nodes/Nodes_container"), "_on_return_images")
	
	# request images from the server
	connect("request_images_from_server", get_node("Tcp_client"), "_on_request_images_from_server")
