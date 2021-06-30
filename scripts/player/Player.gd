extends Entity

onready var rotate := $Rotate
onready var armAnim := $ArmAnimation
onready var anim := $AnimationPlayer
onready var debugFSM := $DebugStateMachine

onready var coyoteTimer := $CoyoteTimer
onready var jumpBuffer := $JumpBuffer
onready var fallingTimer := $FallingTimer
var was_on_floor : bool

onready var sprites := $Sprites
onready var head := $Sprites/HeadSprite
onready var body := $Sprites/BodySprite
onready var lArm := $Sprites/LeftArmSprite
onready var rArm := $Sprites/RightArmSprite
onready var legs := $Sprites/LegsSprite
onready var item := $Sprites/ItemSprite

const ACCELERATION := 512
var MAX_SPEED : int = 96
var FRICTION : float = 0.25
const AIR_RESISTANCE := 0.02
const JUMP_FORCE = 128

var motion := Vector2()
var x_input = 0
var can_pick = true

func damage_entity(damage : float) -> void:
	pass

func _process(delta):
	armAnim.play("shoot")
	lArm.rotation = get_angle_to(get_global_mouse_position())
	rArm.rotation = get_angle_to(get_global_mouse_position())
	print("mouse radians: ", get_angle_to(get_global_mouse_position()))
	print("radians: ", lArm.rotation)

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
		lArm.flip_h = x_input < 0
		rArm.flip_h = x_input < 0
		legs.flip_h = x_input < 0
		rotate_tween()

func start_movement() -> void:
	was_on_floor = is_on_floor()
	motion = move_and_slide(motion, Vector2.UP)

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
