extends KinematicBody2D

class_name Entity

export (String) var entity_name setget set_name, get_name

export (float) var health := 100.0
export (float) var speed := 3.5

func set_name(new_value : String) -> void:
	entity_name = new_value

func get_name() -> String:
	return entity_name
 
func damage_entity(damage : float) -> void:
	pass
