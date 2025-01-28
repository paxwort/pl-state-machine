@icon("res://addons/pl-state-machine/icons/PLStateTransition.svg")
@tool
class_name PLStateTransition extends Node
var source_state : PLState
@export var target_state : PLState
@export var transition_disabled : bool

var connected_transitions : Array[PLStateTransition] = []
signal transitioned

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	if get_parent() is PLStateMachine:
		pass
	elif not get_parent() is PLState:
		warnings.append("PLStateTransition %s must be a child of some PLState, or an only-child of some PLStateMachine"%name)
	if not target_state:
		warnings.append("PLStateTransition %s must have a target"%name)
	return warnings

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		source_state = get_parent() as PLState
		target_state.transition_conditions_changed.connect(_connect_transitions)
	
func _ready():
	if not Engine.is_editor_hint():
		_connect_transitions()

func _connect_transitions():
	connected_transitions.clear()
	if target_state.allow_pass_through:
		for transition in target_state.find_children("*", "PLStateTransition", false):
			connected_transitions.push_back(transition as PLStateTransition)

func transition():
	if !transition_disabled:
		_start_transition()

func _start_transition():
	if source_state.machine.transition_lock(self):
		source_state.exited_state.connect(_end_transition)
		source_state.exit_state()

func _end_transition():
	target_state.enter_state()
	if source_state.exited_state.is_connected(_end_transition):
		source_state.exited_state.disconnect(_end_transition)
	if source_state.machine.transition_unlock(self):
		source_state.machine._next_in_path()
	transitioned.emit()

func abort_transition():
	source_state.machine.transition_unlock(self)
	if source_state.exited_state.is_connected(_end_transition):
		source_state.exited_state.disconnect(_end_transition)
