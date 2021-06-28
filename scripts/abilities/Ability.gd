extends Node

class_name Ability

export (String) var ability_name setget set_name, get_name
export (String) var description setget set_desc, get_desc
export (Texture) var image setget set_image, get_image

func set_name(new_value : String):
	ability_name = new_value

func get_name() -> String:
	return ability_name

func set_desc(new_value : String):
	description = new_value

func get_desc() -> String:
	return description

func set_image(new_value : String):
	var new_image : Texture = load(new_value)
	image = new_image

func get_image() -> Texture:
	return image
