# create wireframey shell of the room
extends Spatial

var Door = load("res://Create_door.tscn")
var Room_shell = load("res://Create_room_shell.tscn")


func _ready():
	# create the outer shell
	var room_shell = Room_shell.instance()
	room_shell.name = "room_shell"
	room_shell.scale = Vector3(global_variables.init_room_scale_x,
						global_variables.init_room_scale_y,
						global_variables.init_room_scale_z)
	self.add_child(room_shell)
	
	var door = Door.instance()
	door.setup(0.25, 0.5)
	door.translation = Vector3(-global_variables.init_room_scale_x, 0, 0)
	door.name = "door"
	self.add_child(door)
	
	# create room door
	#var door : MeshInstance = Door.instance()
	#door.name = "door"
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var room_shell = get_node("room_shell")
	if room_shell != null:
		#cube.translation.z = (-global_variables.room_scale_z)
		room_shell.scale = Vector3(global_variables.init_room_scale_x,
							global_variables.init_room_scale_y,
							global_variables.room_scale_z)
