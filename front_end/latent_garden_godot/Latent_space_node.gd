tool

extends Spatial
# WIP: these constants should be moved to a separate constants file
const RENDERED_IMAGE_MESH_SCALE : Vector3 = Vector3(0.1, 0.1, 0.1)
var is_selected : bool = false
var has_image: bool = false
var is_selectable : bool = true
# WIP implement has_image to avoid requesting images for lat nodes that already have image generated#var has_image: bool = false
var id : int 
	
func set_image_texture(texture: ImageTexture) -> void:
	var mat = $Image_mesh.get_surface_material(0)
	mat.albedo_texture = texture
	$Image_mesh.set_surface_material(0, mat)
	$Image_mesh.visible = true
	$Collider/Mesh.visible = false
	is_selected = false
	has_image = true
	make_image_selectable()

func make_image_selectable() -> void:
	$Collider/Collision_shape.scale = Vector3(Constants.LATENT_NODE_IMAGE_MESH_SCALE/2, 
											Constants.LATENT_NODE_IMAGE_MESH_SCALE/2, 
											Constants.LATENT_NODE_IMAGE_MESH_SCALE/2)

func update_on_selected() -> void:
	is_selected = !is_selected
	if(is_selected && has_image):
		$Image_mesh/Outline_mesh.visible = true
	elif(!is_selected && has_image):
		$Image_mesh/Outline_mesh.visible = false
	elif(is_selected && !has_image):
		$Collider/Mesh.get_surface_material(0).albedo_color = Color(1,0,0)
	elif(!is_selected && !is_selectable):
		$Collider/Mesh.get_surface_material(0).albedo_color = Color(0,1,0)
	else:
		$Collider/Mesh.get_surface_material(0).albedo_color = Color(1.0,1.0,1.0)
	
func _on_z_scale_changed(scalar: float) -> void:
	pass
	# WIP: disabled for now, is scaling of each node even necessary?
	#var collider_mesh_scale = range_lerp(scalar, 0.0, 1.0, Constants.LATENT_NODE_COLLISION_SHAPE_SCALE_MIN, Constants.LATENT_NODE_COLLISION_SHAPE_SCALE_MAX)
	#var collision_shape_scale = range_lerp(scalar, 0.0, 1.0, Constants.LATENT_NODE_MESH_SCALE_MIN, Constants.LATENT_NODE_MESH_SCALE_MAX)
	# DEBUG, mesh has same scale as collision shape
	#$Collider/Mesh.scale = Vector3(collision_shape_scale, collision_shape_scale, collision_shape_scale)
	
	# NOT DEBUG
	#$Collider/Mesh.scale = Vector3(collision_shape_scale, collision_shape_scale, collision_shape_scale)	
	#$Collider/Collision_shape.scale = Vector3(collision_shape_scale, collision_shape_scale, collision_shape_scale)

	
func _on_slice_visibility_changed(is_visible: bool) -> void:
	if(is_visible):
		is_selectable = true
		$Collider/Collision_shape.disabled = false
	else:
		is_selectable = false
		$Collider/Collision_shape.disabled = true		
		
func _ready():
	$Image_mesh.scale = Vector3(Constants.LATENT_NODE_IMAGE_MESH_SCALE,Constants.LATENT_NODE_IMAGE_MESH_SCALE,Constants.LATENT_NODE_IMAGE_MESH_SCALE)
	
#	$Collider/Mesh.scale = Vector3(Constants.LATENT_NODE_MESH_SCALE_MIN, 
#									Constants.LATENT_NODE_MESH_SCALE_MIN, 
#									Constants.LATENT_NODE_MESH_SCALE_MIN)
	$Collider/Mesh.scale = Vector3(Constants.LATENT_NODE_MESH_SCALE_MIN, Constants.LATENT_NODE_MESH_SCALE_MIN, Constants.LATENT_NODE_MESH_SCALE_MIN)
	$Collider/Collision_shape.scale = Vector3(Constants.LATENT_NODE_COLLISION_SHAPE_SCALE_MIN, Constants.LATENT_NODE_COLLISION_SHAPE_SCALE_MIN, Constants.LATENT_NODE_COLLISION_SHAPE_SCALE_MIN)
	# Create and assign textures manually so they can be edited individually per instance	
	var image_mesh_mat : SpatialMaterial = SpatialMaterial.new()
	$Image_mesh.set_surface_material(0, image_mesh_mat)
	var collider_mesh_mat : SpatialMaterial= SpatialMaterial.new()
	collider_mesh_mat.albedo_color = Color(1,1,1)
	$Collider/Mesh.set_surface_material(0, collider_mesh_mat)
	#var bounding_box : Array = Geom.get_bounding_box_from_vec3(NODE_SCALE)
	#Geom.add_debug_box_to_the_scene(self, bounding_box[0], bounding_box[1])

func _process(delta):
	pass


