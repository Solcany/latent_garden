extends Spatial

enum KeyLayout {
	NONE,
	ARROWS,
	WASD_QE,
	ZDSQ_AE
}

export (KeyLayout) var key_layout:int = KeyLayout.WASD_QE

export (float,0,10) var view_sensitivity : float = 0.25
export (float,0,10) var rotation_damping : float = 5
export (float,0,10) var acceleration_speed : float = 0.2
export (float,0,10) var decay_speed : float = 4
export (float,0,30) var max_speed : float = 8
export (bool) var escape : bool = true
export (bool) var move_in_xz : bool = false
export (bool) var constraint_altitude : bool = false
export (float,-10,10) var altitude_min : float = 0.5
export (float,-10,10) var altitude_max : float = 5

var yaw : float = 0
var pitch : float = 0
var directions : Array = [false,false,false,false,false,false] # FRONT, RIGHT, BACK, LEFT, UP, BOTTOM
var momentum : Vector3 = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yaw = self.rotation_degrees.y
	pitch = $cam.rotation_degrees.x

func _input(event):
	if event is InputEventMouseMotion:
		yaw = (fmod(yaw - event.relative.x * view_sensitivity, 360))
		pitch = max(min(pitch - event.relative.y * view_sensitivity, 85), -85)
	elif event is InputEventKey:
		if escape and event.scancode == KEY_ESCAPE and event.pressed:
			get_tree().quit()
		else:
			match ( key_layout ):
				KeyLayout.ARROWS:
					if event.scancode == KEY_UP:
						directions[0] = event.pressed
					elif event.scancode == KEY_RIGHT:
						directions[1] = event.pressed
					elif event.scancode == KEY_DOWN:
						directions[2] = event.pressed
					elif event.scancode == KEY_LEFT:
						directions[3] = event.pressed
				KeyLayout.WASD_QE:
					if event.scancode == KEY_W:
						directions[0] = event.pressed
					elif event.scancode == KEY_D:
						directions[1] = event.pressed
					elif event.scancode == KEY_S:
						directions[2] = event.pressed
					elif event.scancode == KEY_A:
						directions[3] = event.pressed
					elif event.scancode == KEY_Q:
						directions[4] = event.pressed
					elif event.scancode == KEY_E:
						directions[5] = event.pressed
				KeyLayout.ZDSQ_AE:
					if event.scancode == KEY_Z:
						directions[0] = event.pressed
					elif event.scancode == KEY_D:
						directions[1] = event.pressed
					elif event.scancode == KEY_S:
						directions[2] = event.pressed
					elif event.scancode == KEY_Q:
						directions[3] = event.pressed
					elif event.scancode == KEY_A:
						directions[4] = event.pressed
					elif event.scancode == KEY_E:
						directions[5] = event.pressed

func _process(delta):
	var decay : float = min(1.0, decay_speed * delta)
	momentum -= momentum * decay
	if directions[0]:
		momentum.z -= acceleration_speed * delta
	if directions[2]:
		momentum.z += acceleration_speed * delta
	if directions[1]:
		momentum.x += acceleration_speed * delta
	if directions[3]:
		momentum.x -= acceleration_speed * delta
	if directions[4]:
		momentum.y += acceleration_speed * delta
	if directions[5]:
		momentum.y -= acceleration_speed * delta
	var l : float = momentum.length()
	if l > 0 and delta > 0 and l / delta > max_speed:
		momentum = momentum.normalized() * max_speed * delta
	if move_in_xz:
		self.global_transform.origin += global_transform.basis.xform(momentum)
	else:
		self.global_transform.origin += $cam.global_transform.basis.xform(momentum)
	if constraint_altitude:
		if self.global_transform.origin.y < altitude_min:
			self.global_transform.origin.y = altitude_min
		elif self.global_transform.origin.y > altitude_max:
			self.global_transform.origin.y = altitude_max
	var b0 : Basis = Basis( Vector3.UP, rotation.y )
	var b1 : Basis = Basis( Vector3.UP, deg2rad(yaw) )
	self.transform.basis = b0.slerp( b1, min(1.0,rotation_damping*delta) )
	b0 = Basis( Vector3.RIGHT, $cam.rotation.x )
	b1 = Basis( Vector3.RIGHT, deg2rad(pitch) )
	$cam.transform.basis = b0.slerp( b1, min(1.0,rotation_damping*delta) )
