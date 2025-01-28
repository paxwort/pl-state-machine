@icon("res://addons/pl-state-machine/icons/PLState.svg")
@tool
class_name PLState extends Node

var machine : PLStateMachine
var is_enabled : bool

signal exited_state
signal entered_state

signal transition_conditions_changed
@export var allow_pass_through : bool :
	set(value) :
		allow_pass_through = value
		transition_conditions_changed.emit()
	get() :
		return allow_pass_through

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not get_parent() is PLStateMachine:
		warnings.append("PLState %s must have some parent PLStateMachine"%name)
	return warnings

func _enter_tree():
	if(not Engine.is_editor_hint()):
		machine = _find_machine()
	process_mode = PROCESS_MODE_DISABLED

func _find_machine() -> PLStateMachine:
	var node = self
	var root = get_tree().get_root()
	while(node is not PLStateMachine and node != root):
		node = node.get_parent()
	if node is PLStateMachine:
		return node as PLStateMachine
	else:
		return null

func enter_state():
	is_enabled = true;
	entered_state.emit()
	process_mode = PROCESS_MODE_INHERIT

func exit_state():
	is_enabled = false;
	exited_state.emit()
	process_mode = PROCESS_MODE_DISABLED
