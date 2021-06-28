extends Mutator

func _ready() -> void:
	$Timer.set_wait_time(mutatorChooser.timer.get_wait_time())

func _physics_process(delta) -> void:
	pass

func _exit_tree() -> void:
	pass

func _on_Timer_timeout() -> void:
	queue_free()
