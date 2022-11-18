extends MeshInstance

const folder_path = "data/images/sky_watch_friday/"
const image_suffix = ".JPG"
var current_image_index = 0
const images_total = 116 
var textures = []

func _ready():
	for i in range(1, images_total+1):
		var texture_path = folder_path + str(i) + image_suffix
		var texture : Texture = load(texture_path)
		textures.append(texture)

func _on_Timer_timeout():
#	pass
	var mat = SpatialMaterial.new()
	mat.albedo_texture = textures[current_image_index]
	self.set_surface_material(0, mat)	
#
	if(current_image_index == images_total-1): 
		current_image_index = 0
	else:
		current_image_index += 1 			


