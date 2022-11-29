extends Spatial

var radius : float
var center : Vector3

func init(center: Vector3, radius : float) -> void:
	self.radius = radius
	self.center = center
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var circle_mesh : MeshInstance = Shapes.create_circle_mesh_z_normal(center, radius, 50)
	self.add_child(circle_mesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
