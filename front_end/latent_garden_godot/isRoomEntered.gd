extends Area

func handle_body_entered():
	connect("body_entered", get_parent(), "_on_body_entered_room")
	
func handle_body_exited():
	connect("body_exited", get_parent(), "_on_body_exited_room")


func _ready():
	handle_body_entered()
	handle_body_exited()
	##pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):	
	pass
	#var overlaps : Array = get_overlapping_bodies()
#	if !overlaps.empty():
#		emit_signal("player_entered");
#		print("overlaps!")
		
		
#		for ov in overlaps:
#			if(ov.kind && ov.kind == "Portal" && !is_in_portal):
#				is_in_portal = true
#				emit_signal("player_entered_portal")
#	elif(is_in_portal):
#		is_in_portal = false
#		emit_signal("player_left_portal")

#func _on_self_entered(body):
#	print("Detector:" + self.name)	
#	print("body:" + body.name)
