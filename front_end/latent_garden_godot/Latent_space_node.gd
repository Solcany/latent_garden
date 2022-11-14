tool

extends Spatial

const NODE_SCALE : Vector3 = Vector3(0.03, 0.03, 0.03)
var is_selected : bool = false #setget set_is_selected, get_is_selected
var id : int #setget set_id, get_id
#
#func set_is_selected(value : bool) -> void:
#	is_selected = value
#
#func get_is_selected() -> bool:
#	return is_selected
#
#func set_id(value : int) -> void:
#	id = value
#
#func get_id() -> int:
#	return id

func set_image_texture(texture: ImageTexture) -> void:
	print("settting tex")
	var mat = $Image_mesh.get_surface_material(0)
	mat.albedo_texture = texture
	$Image_mesh.set_surface_material(0, mat)
	$Image_mesh.visible = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Collider.scale = NODE_SCALE
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(1,1,1)
	$Collider/Mesh.set_surface_material(0, mat)
	#var bounding_box : Array = Geom.get_bounding_box_from_vec3(NODE_SCALE)
	#Geom.add_debug_box_to_the_scene(self, bounding_box[0], bounding_box[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_selected):
		var mat = $Collider/Mesh.get_surface_material(0)					
		mat.albedo_color = Color(1,0,0)
	else:
		var mat = $Collider/Mesh.get_surface_material(0)					
		mat.albedo_color = Color(1,1,1)


