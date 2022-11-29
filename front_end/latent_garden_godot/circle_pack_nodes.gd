tool
extends Spatial

func _ready():
	var mesh : MeshInstance = Shapes.get_square_mesh()
	self.add_child(mesh)
