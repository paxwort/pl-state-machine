extends Node

var pattern : Array[int]
signal say_color(index : int)
@export var time_between : float = 1

func _ready():
	(get_parent() as PLState).entered_state.connect(_say)

func _say():
	%Simon.increase_pattern_length(1)
	%Simon.generate_next_pattern()
	pattern =[]
	pattern.append_array(%Simon.next_pattern)
	while pattern.size() > 0:
		await get_tree().create_timer(time_between).timeout
		var next = pattern.pop_front()
		say_color.emit(next)
	%GameState.transition_to(%STATE_Simon_Listen)
