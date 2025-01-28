extends Node
@export var state_machine : PLStateMachine
@export var state : PLState

func go_to():
	state_machine.transition_to(state)
