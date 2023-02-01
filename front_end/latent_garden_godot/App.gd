extends Spatial

### ui input signals
signal get_selected_latent_nodes
func _on_submit_generate_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes", "generate")
	
func _on_submit_generate_slerped_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes", "generate_slerped")
	
signal nodes_container_z_scale_changed
func _on_slider_nodes_container_z_scale_value_changed(value) -> void:
	emit_signal("nodes_container_z_scale_changed", value)
	
# relay mouse wheel update from Mouse_wheel ui element
signal mouse_wheel_update
func _on_mouse_wheel_update(value) -> void:
	emit_signal("mouse_wheel_update", value)

### Server IO
# when the Nodes container returns selected latent nodes
signal request_generate_images
signal request_generate_slerped_images

func _on_return_selected_latent_nodes_ids(ids : Array, request_kind : String) -> void:
	if(request_kind == "generate"):
		emit_signal("request_generate_images", ids)
	elif(request_kind == "generate_slerped"):
		emit_signal("request_generate_slerped_images", ids)
	
# when the tcp client receives images from the server
signal return_images
signal return_slerped_images

func _on_server_response_images_returned(data) -> void:
	emit_signal("return_images", data)

func _on_server_response_slerped_images_returned(data) -> void:
	emit_signal("return_slerped_images", data)

func _ready():
	# debug camera
	get_node("Debug_camera").current = false
	
	### Person input
	connect("nodes_container_z_scale_changed", get_node("Nodes"), "_on_nodes_container_z_scale_changed")
	connect("nodes_container_z_scale_changed", get_node("Camera_controller"), "_on_nodes_container_z_scale_changed")
	connect("mouse_wheel_update", get_node("/root/App/Camera_controller"), "_on_mouse_wheel_update")
	connect("mouse_wheel_update", get_node("/root/App/Nodes/Nodes_Selector"), "_on_mouse_wheel_update")
	
	### Server IO
	# query currently selected latent nodes from the Nodes container
	connect("get_selected_latent_nodes", get_node("Nodes/Nodes_container"), "_on_get_selected_latent_nodes")

	# pass image data to the Nodes container
	connect("return_images", get_node("Nodes/Nodes_container"), "_on_return_images")
	connect("return_slerped_images", get_node("Nodes/Nodes_container"), "_on_return_slerped_images")
	
	# request images from the server
	connect("request_generate_images", get_node("Tcp_client"), "_on_request_generate_images")
	connect("request_generate_slerped_images", get_node("Tcp_client"), "_on_request_generate_slerped_images")
	
	connect("mouse_wheel_update", get_node("/root/App/Camera_controller"), "_on_mouse_wheel_update")
