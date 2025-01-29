extends Node

@export var seconds : float = 1
@export var panel : Panel

func _hold_and_flash_panel() -> void:
	var state = get_parent() as PLState
	state.lock_exit(self)
	var tween = get_tree().create_tween()
	panel.modulate = Color.TRANSPARENT
	tween.tween_property(panel, "modulate", Color.WHITE, .2)
	tween.tween_property(panel, "modulate", Color.TRANSPARENT, 3)
	await tween.finished
	
	state.release_exit_lock(self)
