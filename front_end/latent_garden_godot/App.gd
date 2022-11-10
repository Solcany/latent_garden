extends Spatial

signal get_selected_latent_nodes
signal request_images_from_gan_server

func _on_submit_button_pressed() -> void:
	emit_signal("get_selected_latent_nodes")
	
func _on_set_selected_latent_nodes_ids(ids) -> void:
	emit_signal("request_images_from_gan_server", ids)

func _ready():
	connect("get_selected_latent_nodes", $Nodes/Nodes_container, "_on_get_selected_latent_nodes")
	connect("request_images_from_gan_server", $Tcp_client, "_on_request_images_from_gan_server")
