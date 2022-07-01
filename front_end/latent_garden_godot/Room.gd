extends Spatial
var is_player_in_room = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(is_player_in_room)
	if is_player_in_room:
		$RoomContainer.visible = true
	else:
		$RoomContainer.visible = false


func _on_body_entered_room(body):
	is_player_in_room = true
	print("room entered!")
	
func _on_body_exited_room(body):
	is_player_in_room = false
	print("room exited!")	
	
	
