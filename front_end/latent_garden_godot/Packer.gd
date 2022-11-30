extends Reference

class_name Packer

static func apply_force_to_circle(force : Vector3, circle: Dictionary) -> void:
	circle.acceleration += force
	
static func update_circle(circle : Dictionary) -> void:
	circle.velocity += circle.acceleration
	circle.position += circle.velocity
	circle.acceleration *= 0.0
	
static func set_vec_length(vec : Vector3 , new_length: float) -> Vector3:
	return vec.normalized() * new_length

static func check_borders(i : int, circles: Array) -> void:
	var the_circle= circles[i]
	if (the_circle.position.x-the_circle.radius < -1 or the_circle.position.x+the_circle.radius > 1):
	  the_circle.velocity.x*=-1
	  the_circle.update()
	
	if (the_circle.position.y-the_circle.radius < -1 or the_circle.position.y+the_circle.radius > 1):
	  the_circle.velocity.y*=-1
	  the_circle.update()	


static func check_circle_position(i : int, circles : Array) -> void:
	var the_circle = circles[i]
	for j in range(i+1, circles.size()+1):
		var count = 0
		var other_circle
		if(j == circles.size()):
			other_circle = circles[0]
		else:
			other_circle = circles[j]
		var dist = the_circle.position.distance_to(other_circle.position)
		if(dist < the_circle.radius + other_circle.radius):
			count += 1
		if(count == 0):
			the_circle.velocity.x = 0.0
			the_circle.velocity.y = 0.0

static func get_separation_forces(circle1, circle2) -> Vector3:
	var steer: Vector3 = Vector3(0,0,0)
	var dist : float = circle1.position.distance_to(circle2.position)
	if( dist > 0 and dist < circle1.radius + circle2.radius):
		var diff : Vector3 = circle1.position - circle2.position
		diff.normalized()
		diff /= dist
		steer += diff
	return steer
	
static func are_circles_packed(circles) -> bool:
	var total_velocity: float = 0.0
	for circle in circles:
		total_velocity += abs(circle.velocity.x + circle.velocity.y)
	if(total_velocity == 0):
		return true
	else:
		return false
		
static func apply_separation_forces_to_circle(i: int, circles : Array, separate_forces: Array, near_circles: Array) -> void:
	var the_circle = circles[i]
	for j in range(i+1, circles.size()):
		var other_circle = circles[j]
		var force_ij : Vector3 = get_separation_forces(the_circle, other_circle)
		if(force_ij.length() > 0):
			separate_forces[i] += force_ij        
			separate_forces[j] -= force_ij
			near_circles[i] += 1
			near_circles[j] += 1
	if (near_circles[i] > 0):
		separate_forces[i] = separate_forces[i] / float(near_circles[i])
	if(separate_forces[i].length() > 0):
		 separate_forces[i] = set_vec_length(separate_forces[i], Constants.CIRCLE_PACKER_MAX_SPEED)
		 separate_forces[i] -= the_circle.velocity
		 separate_forces[i].limit_length(Constants.CIRCLE_PACKER_MAX_FORCE)
		
	var separation_force = separate_forces[i]
	apply_force_to_circle(separation_force, the_circle)
	update_circle(the_circle)
	
static func vec3s_to_circles(points, radius) -> Array:
	var circles : Array = []
	for point in points:
		var circle : Dictionary = {}
		circle.position = point
		circle.velocity = Vector3(0,0,0)
		circle.acceleration = Vector3(0,0,0)
		circle.radius = radius
		circles.append(circle)
	return circles
	
static func circles_to_vec3s(circles) -> Array:
	var points : Array = []
	for circle in circles:
		points.append(circle.position)
	return points
	
static func pack_circles(circles) -> Array:
	var cs : Array = circles.duplicate(true)
	
	var is_packing_finished : bool = false

	print("packing ", str(circles.size()), " circles")
	var packing_start_time = OS.get_ticks_msec()
	
	while !is_packing_finished:
		var separate_forces : Array = []
		var near_circles : Array = []
		
		for __ in range(cs.size()):
			separate_forces.append(Vector3(0,0,0))
			near_circles.append(0)
			
		for i in range(cs.size()):
			check_circle_position(i, cs)
			apply_separation_forces_to_circle(i, cs, separate_forces, near_circles)	
		is_packing_finished = are_circles_packed(cs)
		
	var total_packing_time : float = float(OS.get_ticks_msec() - packing_start_time) / 1000.0
	print("packing took ", str(total_packing_time), " seconds")
	
	return cs
	
