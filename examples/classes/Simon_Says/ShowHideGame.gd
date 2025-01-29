extends Node

@export var hide : bool
func show_hide() -> void:
	if hide:
		%Game.hide()
	else:
		%Game.show()
