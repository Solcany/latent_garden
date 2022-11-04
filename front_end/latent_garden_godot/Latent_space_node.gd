tool

extends Spatial

const NODE_SCALE = Vector3(0.05, 0.05, 0.05)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RigidBody.scale = NODE_SCALE
	$RigidBody/CollisionShape.scale = NODE_SCALE

	var bounding_box : Array = Geom.get_bounding_box_from_vec3(NODE_SCALE)
	Geom.add_debug_box_to_the_scene(self, bounding_box[0], bounding_box[1])



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
