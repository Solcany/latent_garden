extends Spatial

### Person input signals
signal get_selected_latent_nodes
func _on_submit_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes")

signal nodes_container_z_scale_changed
func _on_slider_nodes_container_z_scale_value_changed(value) -> void:
	emit_signal("nodes_container_z_scale_changed", value)

### Server IO
# when the Nodes container returns selected latent nodes
signal request_images_from_server
func _on_return_selected_latent_nodes_ids(ids) -> void:
	emit_signal("request_images_from_server", ids)
	
# when the tcp client receives images from the server
signal return_images
func _on_server_response_images_returned(data) -> void:
	emit_signal("return_images", data)

func _ready():
	# debug camera
	# get_node("Debug_camera").current = true
	
	### Person input
	connect("nodes_container_z_scale_changed", get_node("Nodes"), "_on_nodes_container_z_scale_changed")
	connect("nodes_container_z_scale_changed", get_node("Camera_controller/Camera"), "_on_nodes_container_z_scale_changed")
		
	### Server IO
	# query currently selected latent nodes from the Nodes container
	connect("get_selected_latent_nodes", get_node("Nodes/Nodes_container"), "_on_get_selected_latent_nodes")

	# pass image data to the Nodes container
	connect("return_images", get_node("Nodes/Nodes_container"), "_on_return_images")
	
	# request images from the server
	connect("request_images_from_server", get_node("Tcp_client"), "_on_request_images_from_server")
