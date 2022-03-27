extends KinematicBody2D

# stats
var score : int = 0
# physics
var speed : int = 200
var jumpForce : int = 600
var gravity : int = 800
var vel : Vector2 = Vector2()

# state
var is_in_portal : bool = false

onready var sprite = $Sprite

func _ready():
	pass 

func _physics_process(delta):
	# reset horizontal velocity
	vel.x = 0
	
	# movement inputs
	# all physics related interactions have to stay
	# in the physics loop
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
	
	# jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
		
	# sprite direction
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
		

func _input(event):
	if event.is_action_released("enter_portal") && is_in_portal:
		print("entering portal")

# event listeners
func _on_areaOverlapChecker_player_entered_portal():
	is_in_portal = true

func _on_areaOverlapChecker_player_left_portal():
	is_in_portal = false
