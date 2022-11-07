tool

extends Spatial

const NODE_SCALE = Vector3(0.03, 0.03, 0.03)
var is_selected = false

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


