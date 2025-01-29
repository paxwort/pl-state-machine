extends Button

func _pressed() -> void:
	%GameState.transition_to(%STATE_Simon_Say)
