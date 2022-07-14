extends Spatial
var is_player_in_room = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_player_in_room:
		$room_contents.visible = true
	else:
		$room_contents.visible = false


func _on_body_entered_room(body):
	#is_player_in_room = true
	print("room entered!")
	
func _on_body_exited_room(body):
	#is_player_in_room = false
	print("room exited!")	
	
	
