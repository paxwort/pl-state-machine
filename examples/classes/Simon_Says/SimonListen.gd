extends Node
var pattern : Array[int]
signal listen_failure
signal listen_success

func _ready():
	(get_parent() as PLState).entered_state.connect(_start_listening)
	(get_parent() as PLState).exited_state.connect(_done_listening)

func _start_listening():
	pattern = %Simon.next_pattern
	var i = 0
	for button in %Simon.Buttons:
		button.pressed.connect(_button_pressed.bind(i))
		i += 1

func _button_pressed(index : int):
	var target_index = pattern.pop_front()
	print("%s : you pressed %s"%[target_index, index])
	if target_index == index:
		listen_success.emit()
	else:
		#failure
		listen_failure.emit()
		%GameState.transition_to(%STATE_Menu)
	if pattern.size() == 0:
		print("success!")
		%GameState.transition_to(%STATE_Simon_Say)

func _done_listening():
	for button in %Simon.Buttons:
		if button.pressed.is_connected(_button_pressed):
			button.pressed.disconnect(_button_pressed)
