@icon("res://addons/pl-state-machine/icons/PLState.svg")
class_name PLState extends Node

var machine : PLStateMachine
var is_enabled : bool
signal enabling
signal disabling

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	return warnings

func _enter_tree() -> void:
	child_entered_tree.connect(_on_child_entered_tree)	

func _on_child_entered_tree(node : Node):
	if node is PLStateBehaviour:
		node.state = self

func enable(prev_state : String = ""):
	is_enabled = true;
	enabling.emit()
	process_mode = PROCESS_MODE_INHERIT

func disable():
	is_enabled = false;
	disabling.emit()
	process_mode = PROCESS_MODE_DISABLED
