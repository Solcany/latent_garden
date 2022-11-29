tool
extends Spatial
var Circle = load("res://Circle.tscn")

var max_speed : float = 0.01;
var max_force : float = 0.1;
var circles : Array
var rng = RandomNumberGenerator.new()

func init_circles() -> void:
	rng.randomize()
	for i in range(50):
		var c = Circle.instance()
		var pos: Vector3 = Vector3(rng.randf_range(-0.4, 0.4), rng.randf_range(-0.4, 0.4), 0)
		c.init(pos, 0.2)
		c.add_to_group("circles")
		self.add_child(c)	
	
func set_vec_length(vec : Vector3 , new_length: float) -> Vector3:
	return vec * new_length / vec.length()

func check_circle_position(circle_i : int, circles : Array) -> void:
	var circle = circles[circle_i]
	for i in range(circle_i+1, circles.size()):
		var count = 0
		var other_circle = circles[i]
		var dist = circle.translation.distance_to(other_circle.translation)
		if(dist < circle.radius + other_circle.radius):
			count += 1
		if(count == 0):
			circle.velocity.x = 0.0
			circle.velocity.y = 0.0

func get_separation_forces(circle1, circle2) -> Vector3:
	var steer: Vector3 = Vector3(0,0,0)
	var dist : float = circle1.translation.distance_to(circle2.translation)
	if( dist > 0 and dist < circle1.radius + circle2.radius):
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
	the_circle.apply_force(separation_force)
	the_circle.update()

func _ready():
	init_circles()
	circles = get_tree().get_nodes_in_group("circles")

func _process(delta):
  for i in range(circles.size()):
	  check_circle_position(i, circles)
	  apply_separation_forces_to_circle(i, circles);
