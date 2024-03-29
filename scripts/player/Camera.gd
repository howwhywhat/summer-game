extends Camera2D

export (OpenSimplexNoise) var noise : OpenSimplexNoise
export (float, 0, 1) var trauma : float = 0.0

export var max_x : int = 150
export var max_y : int = 150
export var max_r : int = 45

export var time_scale = 100

export(float, 0, 1) var decay : float = 0.6

var time : float = 0

func add_trauma(trauma_in):
	trauma = clamp(trauma + trauma_in, 0.0, 1)

func _process(delta):
	time += delta
	
	var shake = pow(trauma, 2)
	offset.x = noise.get_noise_3d(time * time_scale, 0, 0) * max_x * shake
	offset.y = noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
	rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
	
	if trauma > 0.0: trauma = clamp(trauma - (delta * decay), 0.0, 1)
