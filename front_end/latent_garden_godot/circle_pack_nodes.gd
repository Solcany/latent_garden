tool
extends Spatial
var Circle = load("res://Circle.tscn")

var max_speed : float = 1;
var max_force : float = 1;

func init_circles() -> void:
	var c1 = Circle.instance()
	c1.init(Vector3(0,0,0), 1)
	var c2 = Circle.instance()
	c2.init(Vector3(0.2,0.2,0), 1)
	var c3 = Circle.instance()
	c3.init(Vector3(-0.2,0.3,0), 1)
	c1.add_to_group("circles")
	self.add_child(c1)
	self.add_child(c2)
	c2.add_to_group("circles")	
	self.add_child(c3)
	c3.add_to_group("circles")
	
#func check_borders(circle):
#	if (circle.translation.x-circle.radius/2.0 < 0 || circle.position.x+circle.radius/2.0 > width)
#	{
#	  circle_i.velocity.x*=-1;
#	  circle_i.update();
#	}
#	if (circle_i.position.y-circle_i.radius/2 < 0 || circle_i.position.y+circle_i.radius/2 > height)
#	{
#	  circle_i.velocity.y*=-1;
#	  circle_i.update();

func checkCirclePosition(circle_i, circles) -> void:
	var circle = circles[circle_i]
	for i in range(circle_i+1, circles.size()):
		var count = 0
		var other_circle = circles[i]
		var dist = circle.distance_to(other_circle)
		
		if(dist < circle.radius/2.0 + other_circle.radius/2.0):
			count += 1
		
		if(count == 0):
			circle.velocity.x = 0.0
			circle.velocity.y = 0.0
			

func _ready():
	init_circles()


func _process(delta):
  var circles : Array = get_tree().get_nodes_in_group("circles")
  var separate_forces : Array = []
  var near_circles : Array = []

  #for i in range(circles.size()):
	  #checkBorders(i);
	  #checkCirclePosition(i);
	  #applySeparationForcesToCircle(i, separate_forces, near_circles);
	  #displayCircle(i);
