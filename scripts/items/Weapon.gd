extends Item

class_name Weapon

export (String) var weapon_name setget set_name, get_name
export (String) var weapon_description setget set_desc, get_desc
export (float) var damage setget set_damage, get_damage
export (Texture) var image setget set_image, get_image

func set_name(new_value : String) -> void:
	weapon_name = new_value

func get_name() -> String:
	return weapon_name

func set_desc(new_value : String) -> void:
	weapon_description = new_value

func get_desc() -> String:
	return weapon_description

func set_damage(new_value : float) -> void:
	damage = new_value

func get_damage() -> float:
	return damage

func set_image(new_value : String):
	var new_image : Texture = load(new_value)
	image = new_image

func get_image() -> Texture:
	return image
