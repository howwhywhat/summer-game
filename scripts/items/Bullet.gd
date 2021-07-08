extends RigidBody2D

const BULLET_IMPACT_SCENE = preload("res://scenes/weapons/BulletImpact.tscn")

export (float) var damage = 1.0
export (int) var projectile_speed = 1500

func _ready() -> void:
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))

func _on_Bullet_entity_entered(entity):
	if entity is Enemy:
		print("enemy entered")
		entity.damage_entity(damage, self)
	var bulletImpact = BULLET_IMPACT_SCENE.instance()
	bulletImpact.global_position = global_position
	bulletImpact.rotation = rotation
	get_tree().current_scene.add_child(bulletImpact)
	queue_free()

func screen_exited():
	queue_free()
