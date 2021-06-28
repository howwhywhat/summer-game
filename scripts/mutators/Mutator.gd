extends Node

class_name Mutator

var mutatorChooser
export (String) var mutator_name setget set_name, get_name
export (String) var description setget set_desc, get_desc
export (String) var image setget set_image, get_image

func set_name(new_value : String):
	mutator_name = new_value

func get_name() -> String:
	return mutator_name

func set_desc(new_value : String):
	description = new_value

func get_desc() -> String:
	return description

func set_image(new_value : String):
	image = new_value

func get_image() -> Texture:
	var loadedImg : Texture = load(image)
	return loadedImg
