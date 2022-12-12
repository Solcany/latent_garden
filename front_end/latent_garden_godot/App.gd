extends Spatial

### Person input signals
signal get_selected_latent_nodes
func _on_submit_generate_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes", "generate")
func _on_submit_add_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes", "add")
	
signal nodes_container_z_scale_changed
func _on_slider_nodes_container_z_scale_value_changed(value) -> void:
	emit_signal("nodes_container_z_scale_changed", value)

### Server IO
# when the Nodes container returns selected latent nodes
signal request_generate_images
signal request_add_images

func _on_return_selected_latent_nodes_ids(ids : Array, request_kind : String) -> void:
	if(request_kind == "generate"):
		emit_signal("request_generate_images", ids)
	elif(request_kind == "add"):
		emit_signal("request_add_images", ids)
	
# when the tcp client receives images from the server
signal return_images
func _on_server_response_images_returned(data) -> void:
	emit_signal("return_images", data)

func _ready():
	# debug camera
	get_node("Debug_camera").current = true
	
	### Person input
	connect("nodes_container_z_scale_changed", get_node("Nodes"), "_on_nodes_container_z_scale_changed")
	connect("nodes_container_z_scale_changed", get_node("Camera_controller/Camera"), "_on_nodes_container_z_scale_changed")
		
	### Server IO
	# query currently selected latent nodes from the Nodes container
	connect("get_selected_latent_nodes", get_node("Nodes/Nodes_container"), "_on_get_selected_latent_nodes")

	# pass image data to the Nodes container
	connect("return_images", get_node("Nodes/Nodes_container"), "_on_return_images")
	
	# request images from the server
	connect("request_generate_images", get_node("Tcp_client"), "_on_request_generate_images")
	connect("request_add_images", get_node("Tcp_client"), "_on_request_add_images")
