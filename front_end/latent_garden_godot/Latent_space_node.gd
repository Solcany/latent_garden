tool

extends Spatial
# WIP: these constants should be moved to a separate constants file
const RENDERED_IMAGE_MESH_SCALE : Vector3 = Vector3(0.1, 0.1, 0.1)
var is_selected : bool = false
var is_selectable : bool = true
# WIP implement has_image to avoid requesting images for lat nodes that already have image generated
#var has_image: bool = false
var id : int 
	
func set_image_texture(texture: ImageTexture) -> void:
	var mat = $Image_mesh.get_surface_material(0)
	mat.albedo_texture = texture
	$Image_mesh.set_surface_material(0, mat)
	$Image_mesh.visible = true
	# unselect the node after image was generated
	is_selected = false
	#has_image = true

func _on_update_latent_node_scale(scale: float) -> void:
	$Collider/Mesh.scale = Vector3(scale, scale, scale)
	
func _on_update_latent_node_visibility(is_visible: bool) -> void:
	if(is_visible):
		is_selectable = true
	else:
		is_selectable = false
		
func _ready():
	$Image_mesh.scale = RENDERED_IMAGE_MESH_SCALE
	$Collider.scale = Constants.LATENT_NODE_COLLIDER_SCALE

		
	# Create and assign textures manually so they can be edited individually per instance	
	var image_mesh_mat : SpatialMaterial = SpatialMaterial.new()
	$Image_mesh.set_surface_material(0, image_mesh_mat)
	var collider_mesh_mat : SpatialMaterial= SpatialMaterial.new()
	collider_mesh_mat.albedo_color = Color(1,1,1)
	$Collider/Mesh.set_surface_material(0, collider_mesh_mat)
	#var bounding_box : Array = Geom.get_bounding_box_from_vec3(NODE_SCALE)
	#Geom.add_debug_box_to_the_scene(self, bounding_box[0], bounding_box[1])

func _process(delta):
	if(is_selected):
		$Collider/Mesh.get_surface_material(0).albedo_color = Color(1,0,0)
	elif(!is_selected && !is_selectable):
		$Collider/Mesh.get_surface_material(0).albedo_color = Color(0,1,0)		
	else:
		$Collider/Mesh.get_surface_material(0).albedo_color = Color(1,1,1)


