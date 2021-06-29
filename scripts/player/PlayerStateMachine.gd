extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("fall_impact")
	add_state("shoot")
	call_deferred("set_state", states.idle)

func _state_logic(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.start_movement()
	parent.apply_movement(delta)
	parent.apply_jump()

func _get_transition(delta : float):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.motion.y < 0 and !parent.jumpBuffer.is_stopped():
					return states.jump
				elif parent.motion.y > 0 and parent.coyoteTimer.is_stopped():
					return states.fall
			elif parent.x_input != 0:
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				if parent.motion.y < 0 and !parent.jumpBuffer.is_stopped():
					return states.jump
				elif parent.motion.y > 0 and parent.coyoteTimer.is_stopped():
					return states.fall
			elif parent.x_input == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.motion.y > 0 and !parent.is_on_floor() and parent.coyoteTimer.is_stopped():
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.fall_impact
			elif parent.motion.y < 0 and !parent.jumpBuffer.is_stopped():
				return states.jump
		states.fall_impact:
			if parent.fallingTimer.is_stopped():
				return states.idle
			if !parent.is_on_floor():
				if parent.motion.y < 0 and !parent.jumpBuffer.is_stopped():
					return states.jump
		states.shoot:
			pass
	return null

func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.idle:
			parent.debugFSM.set_text("idle")
			parent.anim.play('idle')
			yield(parent.rotate, "tween_completed")
			parent.rotate.interpolate_property(parent.sprites, "rotation",
				parent.sprites.rotation, 0,
				0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			parent.rotate.start()
		states.walk:
			parent.debugFSM.set_text("walk")
			parent.anim.play("walk")
		states.jump:
			parent.debugFSM.set_text("jumping")
			parent.anim.play("jump")
			parent.jumpBuffer.stop()
		states.fall:
			parent.debugFSM.set_text("fall")
			parent.anim.play("fall")
			if !parent.is_on_floor() and parent.was_on_floor:
				parent.coyoteTimer.start()
		states.fall_impact:
			parent.debugFSM.set_text("fall_impact")
			parent.anim.play("fall_impact")
		states.shoot:
			pass

func _exit_state(old_state, new_state) -> void:
	match old_state:
		states.walk:
			yield(parent.rotate, "tween_completed")
			parent.rotate.interpolate_property(parent.sprites, "rotation",
				parent.sprites.rotation, 0,
				0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			parent.rotate.start()
		states.fall:
			parent.fallingTimer.start()
