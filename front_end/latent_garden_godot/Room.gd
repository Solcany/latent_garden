extends Spatial

var room_index = 0

var is_player_in_room = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	if is_player_in_room:
		$frames.visible = true
	else:
		$frames.visible = false

func _on_body_entered_room(body):
	pass
	#is_player_in_room = true
	#print("room entered!")
	
func _on_body_exited_room(body):
	pass
	#is_player_in_room = false
	#print("room exited!")	
	
	
