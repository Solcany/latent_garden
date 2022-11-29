tool
extends Spatial

func _ready():
	#var mesh : MeshInstance = Shapes.get_square_mesh()
	#self.add_child(mesh)
	self.add_child(Shapes.create_circle_mesh_z_normal())
