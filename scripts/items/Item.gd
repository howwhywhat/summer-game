extends RigidBody2D

class_name Item

export (float) var lightStrength = 1.0
export (NodePath) var lightSourcePath
export (NodePath) var itemTexture
export (NodePath) var detectorPath
onready var detector = get_node(detectorPath)
onready var itemSprite : Sprite = get_node(itemTexture)
onready var lightSource : LightSource = get_node_or_null(lightSourcePath)

var picked = false
onready var mainScene = get_parent()
onready var player = get_parent().get_node("Player")

func _process(_delta) -> void:
	if picked == true:
		get_parent().remove_child(self)
		player.add_child(self)
		get_parent().item.set_texture(itemSprite.get_texture())
		
		visible = false
		if lightSource != null:
			lightSource.strength = 0
		sleeping = true
	else:
		player.item.set_texture(null)
		
		visible = true
		if lightSource != null:
			lightSource.strength = lightStrength
		sleeping = false

func _unhandled_input(event) -> void:
	if event.is_action_pressed("interact"):
		var bodies = detector.get_overlapping_bodies()
		for b in bodies:
			if b is Entity and b.get_name() == "Player" and picked == false:
				picked = true
				player.can_pick = false
	
	if event.is_action_pressed("drop") and picked == true:
		get_parent().remove_child(self)
		mainScene.add_child(self)
		global_position = player.global_position
		picked = false
		player.can_pick = true
