extends Node

onready var current_level = $Level1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level.connect("level_changed", self, "handle_level_changed")
	pass # Replace with function body.

func handle_level_changed(current_level_name : String):
	var next_level 
	var next_level_name: String
	
	match current_level_name:
		"1":
			next_level_name = "1"
		"2":
			next_level_name = "2"
		_:
			return

		next_level = load("res://Level" + next_level_name + ".tscn").instance()
		add_child(next_level)
		next_level.connect("level_changed", self, handle_level_changed)
		current_level.queue_free()
		current_level = next_level			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
