extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		#cube.translation.z = (-global_variables.room_scale_z)
		self.scale = Vector3(global_variables.init_room_scale_x,
							global_variables.init_room_scale_y,
							global_variables.room_scale_z)
