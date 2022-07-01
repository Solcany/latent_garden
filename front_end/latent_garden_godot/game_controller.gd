extends Node

# global_variables is a standalone script with all global vars
# it's autoloaded through Project -> Project Setttings -> Autoload
# setting 'singleton' property to true allows to refer to the vars directly
# from anywhere in the project

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("inc_warp"): global_variables.warp += 0.01
	if event.is_action_pressed("dec_warp"): global_variables.warp -= 0.01
	if event.is_action_pressed("inc_origin"): global_variables.origin += 0.1
	if event.is_action_pressed("dec_origin"): global_variables.origin -= 0.1
