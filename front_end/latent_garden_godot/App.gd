extends Spatial

signal get_selected_latent_nodes

func _on_submit_button_pressed() -> void:
	emit_signal("query_selected_latent_nodes")
	print("pressed")
	
func _on_set_selected_latent_nodes_ids(ids) -> void:
	print(ids)

func _ready():
	var nodes_container_ref = get_node("Nodes/Nodes_container")
	connect("get_selected_latent_nodes", nodes_container_ref, "_on_get_selected_latent_nodes")

