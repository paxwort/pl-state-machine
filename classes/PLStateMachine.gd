@icon("res://addons/pl-state-machine/icons/PLStateMachine.svg")
class_name PLStateMachine extends Node

var _states : Dictionary = {}
@export var active_state_key : String

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	return warnings

func _enter_tree():
	child_entered_tree.connect(_on_child_entered_tree)

func _on_child_entered_tree(node : Node):
	if node is PLState:
		_states[node.name] = node
		node.machine = self

func _ready():
	_enable_current_state()

func _transition_to_by_name(state_name : String):
	var state : PLState = _states.get(state_name)
	if state == null:
		return
	_disable_current_state()
	active_state_key = state_name
	_enable_current_state()

func _disable_current_state():
	var current_state : PLState = _states.get(active_state_key)
	if current_state != null:
		current_state.disable()

func _enable_current_state():

	var current_state : PLState = _states.get(active_state_key)
	if current_state != null:
		current_state.enable()

#I think this is actually the only thing that ever needs to be publically accessible
func transition_to(state):
	if state is String:
		_transition_to_by_name(state)
	elif state is PLState:
		_transition_to_by_name(state.name)
