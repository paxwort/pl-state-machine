extends Button
var state : PLState

func _ready():
	state = get_parent() as PLState
	if state:
		state.entered_state.connect(on)
		state.exited_state.connect(off)
		

func go_to():
	if state.machine:
		state.machine.transition_to(state)

func on():
	disabled = true

func off():
	disabled = false
