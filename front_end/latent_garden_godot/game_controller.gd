extends Node
signal room_scale_changed
# global_variables is a standalone script with all global vars
# it's autoloaded through Project -> Project Setttings -> Autoload
# setting 'singleton' property to true allows to refer to the vars directly
# from anywhere in the project

func handle_room_scale_changed():
	var rooms_ref = get_parent().get_node("rooms")
	connect("room_scale_changed", rooms_ref , "_on_room_scale_changed")

func _ready():
	set_process_input(true)
	handle_room_scale_changed()
	
func _input(event):
	#if event.is_action_pressed("inc_room_scale"): global_variables.room_scale += global_variables.room_scalar
	#if event.is_action_pressed("dec_room_scale"): global_variables.room_scale -= global_variables.room_scalar
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				global_variables.room_scale_z += global_variables.room_scaling_step_z
				self.emit_signal("room_scale_changed")

			if event.button_index == BUTTON_WHEEL_DOWN:
				global_variables.room_scale_z -= global_variables.room_scaling_step_z
				self.emit_signal("room_scale_changed")
				if(global_variables.room_scale_z < global_variables.init_room_scale_z): 
					global_variables.room_scale_z = global_variables.init_room_scale_z



