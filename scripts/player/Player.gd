extends Entity

class_name Player

onready var rotate := $Rotate
onready var armAnim := $ArmAnimation
onready var anim := $AnimationPlayer
onready var debugFSM := $DebugStateMachine

onready var coyoteTimer := $CoyoteTimer
onready var jumpBuffer := $JumpBuffer
onready var fallingTimer := $FallingTimer
var was_on_floor : bool

onready var sprites := $Sprites
onready var armSprites := $ArmSprites
onready var head := sprites.get_node("HeadSprite")
onready var body := sprites.get_node("BodySprite")
onready var lArm := armSprites.get_node("LeftArmSprite")
onready var rArm := armSprites.get_node("RightArmSprite")
onready var legs := sprites.get_node("LegsSprite")
onready var item := find_node("ItemSprite")
onready var holsterPosition := find_node("HolsterPosition")
onready var bulletPosition := find_node("BulletPosition")
onready var smokePosition := find_node("SmokePosition")
onready var recoil := $Recoil

const ACCELERATION := 512
var FRICTION : float = 0.25
const AIR_RESISTANCE := 0.02
const JUMP_FORCE = 128

var x_input = 0
var can_pick = true
var lookingRight = false
var lookingLeft = false

func _process(_delta) -> void:
	if !can_pick:
		look_at_mouse()
	else:
		rotate_arms()

func damage_entity(damage : float, damager : Entity) -> void:
	.damage_entity(damage, damager)

func look_at_mouse() -> void:
	armAnim.play("shoot")

	if get_global_mouse_position().x > global_position.x:
		lookingRight = true
		lookingLeft = false
		
		item.get_parent().remove_child(item)
		rArm.add_child(item)
		holsterPosition.get_parent().remove_child(holsterPosition)
		rArm.add_child(holsterPosition)
		bulletPosition.get_parent().remove_child(bulletPosition)
		rArm.add_child(bulletPosition)
		smokePosition.get_parent().remove_child(smokePosition)
		rArm.add_child(smokePosition)
		
		lArm.scale.x = -1
		rArm.scale.x = 1
		item.position.x = 1
		bulletPosition.position.x = 4
		smokePosition.position.x = 5
		item.flip_h = false
	else:
		lookingLeft = true
		lookingRight = false
		
		item.get_parent().remove_child(item)
		lArm.add_child(item)
		holsterPosition.get_parent().remove_child(holsterPosition)
		lArm.add_child(holsterPosition)
		bulletPosition.get_parent().remove_child(bulletPosition)
		lArm.add_child(bulletPosition)
		smokePosition.get_parent().remove_child(smokePosition)
		lArm.add_child(smokePosition)
		
		lArm.scale.x = 1
		rArm.scale.x = -1
		item.position.x = -4
		bulletPosition.position.x = -8
		smokePosition.position.x = -9
		item.flip_h = true
	
	if lookingRight:
		rArm.rotation = get_angle_to(get_global_mouse_position())
		rArm.rotation_degrees = wrapf(rArm.rotation_degrees, -90, 90)
		lArm.rotation = holsterPosition.rotation
	if lookingLeft:
		lArm.rotation = get_angle_to(get_global_mouse_position())
		lArm.rotation_degrees = wrapf(lArm.rotation_degrees, -90, 90)
		rArm.rotation = holsterPosition.rotation
	bulletPosition.rotation = get_angle_to(get_global_mouse_position())
	smokePosition.rotation = get_angle_to(get_global_mouse_position())

func apply_gravity(delta : float) -> void:
	if coyoteTimer.is_stopped():
		motion.y += GlobalConstants.GRAVITY * delta
		motion.y += GlobalConstants.GRAVITY * delta

func apply_jump() -> void:
	if is_on_floor() || !coyoteTimer.is_stopped():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("up"):
			coyoteTimer.stop()
			motion.y = -JUMP_FORCE
	else:
		jumpBuffer.start()
		if Input.is_action_just_pressed("up") and motion.y < -JUMP_FORCE / 2:
			coyoteTimer.stop()
			motion.y = -JUMP_FORCE / 2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)

func apply_movement(delta : float) -> void:
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		head.flip_h = x_input < 0
		body.flip_h = x_input < 0
		legs.flip_h = x_input < 0
		rotate_tween()

func start_movement() -> void:
	was_on_floor = is_on_floor()
	motion = move_and_slide(motion, Vector2.UP)

func dropped_item() -> void:
	anim.play("idle")
	armAnim.play("idle")
	lArm.scale.x = 1
	rArm.scale.x = 1
	lArm.rotation = 0
	rArm.rotation = 0

func rotate_tween():
	if rotate.is_active():
		return
	rotate.interpolate_property(sprites, "rotation",
		rotation, rotation + deg2rad(20),
		0.25, Tween.TRANS_SINE, Tween.EASE_IN)
	rotate.start()
	yield(rotate, "tween_completed")
	rotate.interpolate_property(sprites, "rotation",
		rotation, rotation + deg2rad(-20),
		0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
	rotate.start()

func item_recoil() -> void:
	pass

func rotate_arms():
	if can_pick:
		armSprites.rotation = sprites.rotation
