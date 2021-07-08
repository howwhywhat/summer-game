extends Weapon

class_name Gun

export (PackedScene) var weaponSmoke
export (PackedScene) var bullet
export (float) var rate_of_fire
export (bool) var can_fire
export (float) var knockbackIntensity

func _process(_delta) -> void:
	if Input.is_action_pressed("shoot"):
		fire()

func fire() -> void:
	pass
