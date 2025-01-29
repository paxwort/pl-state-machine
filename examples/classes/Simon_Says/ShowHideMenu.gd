extends Node

@export var hide : bool

func show_hide() -> void:
	if hide:
		%Menu.hide()
	else:
		%Menu.show()
