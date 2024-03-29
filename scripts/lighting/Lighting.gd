extends ColorRect

export (NodePath) var camera_path

var image = Image.new()
var texture = ImageTexture.new()

func _ready():
	image.create(128, 2, false, Image.FORMAT_RGBAH)

func _physics_process(delta):
	_update_texture()
	var t = Transform2D(0, Vector2())
	var camera = get_node_or_null(camera_path)
	if camera != null:
		var canvas_transform = camera.get_canvas_transform()
		var top_left = -canvas_transform.origin / canvas_transform.get_scale()
		t = Transform2D(0, top_left)
	material.set_shader_param("global_transform", t)

func _update_texture():
	var lights = get_tree().get_nodes_in_group("Lights")
	image.lock()
	for i in lights.size():
		var light = lights[i]
		if light is LightSource:
			var light_position = light.global_position.floor()
			image.set_pixel(i, 0, Color( \
					light_position.x, light_position.y, \
					light.strength, light.radius))
			image.set_pixel(i, 1, light.color)
	image.unlock()
	
	texture.create_from_image(image)
	material.set_shader_param("n_lights", lights.size())
	material.set_shader_param("light_data", texture)
