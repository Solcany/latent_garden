extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):	
	var overlaps : Array = get_overlapping_bodies()
	if !overlaps.empty():
#		emit_signal("player_entered");
		print("overlaps!")
		
		
#		for ov in overlaps:
#			if(ov.kind && ov.kind == "Portal" && !is_in_portal):
#				is_in_portal = true
#				emit_signal("player_entered_portal")
#	elif(is_in_portal):
#		is_in_portal = false
#		emit_signal("player_left_portal")
		
