extends Spatial

var radius : float
var velocity: Vector3
var acceleration: Vector3
var has_neighbours: bool = true

func init(position: Vector3, radius : float) -> void:
	var circle_mesh : MeshInstance = Shapes.create_circle_mesh_z_normal(Vector3(0,0,0), radius, 50)
	self.add_child(circle_mesh)
	
	# WIP: add filled mesh to the center of the circle, the func is broken atm
	#var c_mesh : MeshInstance = Shapes.test_create_circle_mesh_z_normal(Vector3(0,0,0), radius/2, 25)
	#self.add_child(c_mesh)
	
	self.translation = position
	self.radius = radius
	
func apply_force(force : Vector3) -> void:
	self.acceleration += force
	
func update() -> void:
	self.velocity += self.acceleration
	self.translation += self.velocity
	self.acceleration *= 0.0

func _ready():
	pass

