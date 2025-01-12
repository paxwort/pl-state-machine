#PLStateBehaviour is a simple utility class with some QOL.
#Inherit from this for prebuilt connections to the parent State
@icon("res://addons/pl-state-machine/icons/PLStateBehaviour.svg")
class_name PLStateBehaviour extends Node

var state : PLState :
	set(value) :
		if(state != null):
			state.enabling.disconnect(_on_state_enabling)
			state.disabling.disconnect(_on_state_disabling)
		value.enabling.connect(_on_state_enabling)
		value.disabling.connect(_on_state_disabling)
		state = value
	get:
		return state

func _on_state_enabling() -> void:
	pass

func _on_state_disabling() -> void:
	pass
