extends Gun

func fire() -> void:
	if !picked:
		return

	if !can_fire:
		return
	
	can_fire = false
	var instancedBullet = bullet.instance()
	instancedBullet.global_position = get_parent().bulletPosition.global_position
	instancedBullet.rotation = get_parent().bulletPosition.rotation
	get_tree().current_scene.add_child(instancedBullet)

	var instancedWeaponSmoke = weaponSmoke.instance()
	instancedWeaponSmoke.global_position = get_parent().smokePosition.global_position
	instancedWeaponSmoke.rotation = get_parent().smokePosition.rotation
	instancedWeaponSmoke.scale = Vector2(0.5, 0.5)
	get_tree().current_scene.add_child(instancedWeaponSmoke)

	var knockbackAmount = get_parent().transform.get_origin() - get_global_mouse_position()
	get_parent().knockback_entity(knockbackAmount, knockbackIntensity)
	
	if get_parent().lookingRight:
		get_parent().item.position.x -= 2
		get_parent().item.rotation_degrees -= 25
	else:
		get_parent().item.position.x += 2
		get_parent().item.rotation_degrees += 25
	yield(get_tree().create_timer(rate_of_fire), "timeout")
	can_fire = true
	if get_parent() is Player:
		if get_parent().lookingRight:
			get_parent().item.position.x += 2
		else:
			get_parent().item.position.x -= 2
		get_parent().item.rotation_degrees = 0
