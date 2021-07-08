extends KinematicBody2D

class_name Entity

var last_damager : Entity setget set_last_damager, get_last_damager
export (String) var entity_name setget set_name, get_name

export (float) var health := 100.0
export (float) var speed := 3.5
var MAX_SPEED : int = 96
var motion := Vector2()

func set_name(new_value : String) -> void:
	entity_name = new_value

func get_name() -> String:
	return entity_name
 
func set_last_damager(new_last_damager):
	last_damager = new_last_damager

func get_last_damager() -> Entity:
	return last_damager

func damage_entity(damage : float, damager : Entity) -> void:
	set_last_damager(damager)

func knockback_entity(direction : Vector2, intensity : float) -> void:
	motion = direction.normalized() * intensity * MAX_SPEED
