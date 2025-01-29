extends ColorRect

var state : PLState

func _ready():
	state = get_parent() as PLState
	if state:
		state.entered_state.connect(on)
		state.exited_state.connect(off)

func on():
	get_tree().create_tween().tween_property(self, "color", Color.WEB_GREEN, .1)

func off():
	get_tree().create_tween().tween_property(self, "color", Color.hex(0x424242), .1)
