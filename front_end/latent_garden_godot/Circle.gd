extends Spatial

var radius : float = 1
var center : Vector3
var velocity: Vector3
var acceleration: Vector3

func init(position: Vector3, radius : float) -> void:
	var circle_mesh : MeshInstance = Shapes.create_circle_mesh_z_normal(Vector3(0,0,0), radius, 50)
	self.add_child(circle_mesh)
	self.translation = position
	
func apply_force(force : Vector3) -> void:
	self.acceleration += force
	
func update() -> void:
	#self.velocity += self.acceleration
	#self.translation += self.velocity
	#self.translation = self.position
	#self.acceleration *= 0.0
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

