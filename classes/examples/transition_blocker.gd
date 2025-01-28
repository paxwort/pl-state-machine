extends CheckButton


# Called when the node enters the scene tree for the first time.
func _toggled(toggled_on: bool) -> void:
	var transition = get_parent() as PLStateTransition
	if toggled_on and transition:
		transition.transition_disabled = true
	elif transition:
		transition.transition_disabled = false
