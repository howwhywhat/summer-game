extends CanvasLayer

onready var timer := $Timer
onready var mutatorName := $MutatorName
onready var mutatorDesc := $MutatorDescription
onready var mutatorImage := $MutatorImage

const MUTATORS = ["res://scenes/mutators/TestMutator.tscn"]

func _on_Timer_timeout():
	randomize()
	var finalValue : String = MUTATORS[randi() % MUTATORS.size()]
	var mutatorScene := load(finalValue)
	var mutator = mutatorScene.instance()
	mutator.mutatorChooser = self
	get_parent().add_child(mutator)

	mutatorName.set_text(mutator.get_name())
	mutatorDesc.set_text(mutator.get_desc())
	mutatorImage.set_texture(mutator.get_image())
