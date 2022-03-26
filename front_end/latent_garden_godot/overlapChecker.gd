extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = $Sprite
var is_in_portal : bool = false
signal player_entered_portal
signal player_left_portal

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)
	pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	var overlaps : Array = get_overlapping_areas()
	if !overlaps.empty():
		for ov in overlaps:
			if(ov.kind && ov.kind == "Portal" && !is_in_portal):
				is_in_portal = true
				emit_signal("player_entered_portal")
	elif(is_in_portal):
		is_in_portal = false
		emit_signal("player_left_portal")
		

		#player.unsetIsInPortal()

