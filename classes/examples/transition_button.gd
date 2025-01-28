extends Button

func _pressed() -> void:
	var transition = get_parent() as PLStateTransition
	transition.transition()
