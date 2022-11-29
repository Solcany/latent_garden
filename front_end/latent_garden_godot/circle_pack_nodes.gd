tool
extends Spatial
var Circle = load("res://Circle.tscn")

var max_speed : float = 1;
var max_force : float = 1;
var circles : Array

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

func set_vec_length(vec : Vector3 , new_length: float) -> Vector3:
	return vec * new_length / vec.length()

func check_circle_position(circle_i : int, circles : Array) -> void:
	var circle = circles[circle_i]
	for i in range(circle_i+1, circles.size()):
		var count = 0
		var other_circle = circles[i]
		var dist = circle.translation.distance_to(other_circle.translation)
		
		if(dist < circle.radius/2.0 + other_circle.radius/2.0):
			count += 1
		
		if(count == 0):
			circle.velocity.x = 0.0
			circle.velocity.y = 0.0

func get_separation_forces(circle1, circle2) -> Vector3:
	var steer: Vector3 = Vector3(0,0,0)
	var dist : float = circle1.distance_to(circle2)
	
	if( dist > 0 and dist < circle1.radius/2.0 + circle2.radius/2.0):
		var diff : Vector3 = circle1.translation - circle2.translation
		diff = diff.normalized()
		diff /= dist
		steer += diff
	
	return steer
	
func apply_separation_forces_to_circle(i: int, circles : Array) -> void:
	var separate_forces : Array = []
	var near_circles : Array = []
	for _i in range(circles.size()):
		separate_forces.append(Vector3(0,0,0))
		near_circles.append(0)
		
	var the_circle = circles[i]
	for j in range(i+1, circles.size()):
		var other_circle = circles[j]
		var force_ij : Vector3 = get_separation_forces(the_circle, other_circle)
		if(force_ij.length() > 0):
			separate_forces[i] += force_ij        
			separate_forces[j] += force_ij
			near_circles[i] += 1
			near_circles[j] += 1
	if (near_circles[i] > 0):
		separate_forces[i] = separate_forces[i] / float(near_circles[i])
	if(separate_forces[i].length() > 0):
		 separate_forces[i] = set_vec_length(separate_forces[i], max_speed)
		 separate_forces[i] -= the_circle.velocity
		 separate_forces[i].limit_length(max_force)
		
	var separation_force = separate_forces[i]
	the_circle.applyForce(separation_force);
	the_circle.update();



#  void applySeparationForcesToCircle(int i, PVector[] separate_forces, int[] near_circles) {
#	if (separate_forces[i]==null)
#	  separate_forces[i]=new PVector();
#	Circle circle_i=circles.get(i);
#	for (int j=i+1; j<circles.size(); j++) {
#	  if (separate_forces[j] == null) 
#		separate_forces[j]=new PVector();
#	  Circle circle_j=circles.get(j);
#	  PVector forceij = getSeparationForce(circle_i, circle_j);
#	  if (forceij.mag()>0) {
#		separate_forces[i].add(forceij);        
#		separate_forces[j].sub(forceij);
#		near_circles[i]++;
#		near_circles[j]++;
#	  }
#	}
#	if (near_circles[i]>0) {
#	  separate_forces[i].div((float)near_circles[i]);
#	}
#	if (separate_forces[i].mag() >0) {
#	  separate_forces[i].setMag(max_speed);
#	  separate_forces[i].sub(circles.get(i).velocity);
#	  separate_forces[i].limit(max_force);
#	}
#	PVector separation = separate_forces[i];
#	circles.get(i).applyForce(separation);
#	circles.get(i).update();
#  }

func _ready():
	init_circles()
	circles = get_tree().get_nodes_in_group("circles")

func _process(delta):
  for i in range(circles.size()):
	  #checkBorders(i);
	  check_circle_position(i, circles)
	  apply_separation_forces_to_circle(i, circles);
	  #displayCircle(i);
