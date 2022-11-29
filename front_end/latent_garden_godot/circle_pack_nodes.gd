tool
extends Spatial
var Circle = load("res://Circle.tscn")


func _ready():
	var c1 = Circle.instance()
	c1.init(Vector3(0,0,0), 1)
	var c2 = Circle.instance()
	c2.init(Vector3(0.2,0.2,0), 1)

	self.add_child(c1)
	self.add_child(c2)
