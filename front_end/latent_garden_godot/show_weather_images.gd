extends MeshInstance

const folder_path = "data/images/sky_watch_friday/"
const image_prefix = "010"
const image_suffix = ".JPG"

var current_image_index = 0
const images_total = 116

var textures = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var path_index = 24	
	for _i in range(images_total):
		var texture_path = folder_path + image_prefix + str(path_index) + image_suffix
		var texture : Texture = load(texture_path)
		textures.append(texture)
		path_index += 1
#	var m = self.get_surface_material(0)
#	var mat = SpatialMaterial.new()
#	mat.albedo_color = Color(255, 1, 0)
#	#print(m)
#	self.set_material_override(mat)	

	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
#	pass
	var mat = SpatialMaterial.new()
	mat.albedo_texture = textures[current_image_index]
	self.set_surface_material(0, mat)	
#
	if(current_image_index > images_total-2): 
		current_image_index = 0
	else:
		current_image_index += 1 			


