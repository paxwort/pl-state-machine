@icon("res://addons/pl-state-machine/icons/PLStateMachine.svg")
class_name PLStateMachine extends Node

var _states : Dictionary = {}
var _root_transition : PLStateTransition
var active_state : PLState
@export var initial_state : PLState

func _enter_tree():
	child_entered_tree.connect(_child_entered_tree)
	child_exiting_tree.connect(_child_exiting_tree)

func _ready():
	if !Engine.is_editor_hint():
		_start_machine()
	
func _start_machine():
	if initial_state:
		active_state = initial_state
	else:
		active_state = _states.keys().front()
	active_state.enter_state()

var current_path : Array[PLStateTransition] = []

func transition_to(target_state : PLState) -> void:
	if !_states.has(target_state):
		push_warning("The PLStateMachine %s tried to transition to a state that it was not aware of"%name)
		return
	current_path = _get_path_to_state(active_state, target_state)
	_next_in_path()

func _next_in_path() -> void:
	if current_path.size() > 0:
		var next : PLStateTransition = current_path.pop_back()
		next.transition()

var transition_lock_owner : PLStateTransition = null
func transition_lock(transition : PLStateTransition) -> bool:
	if transition.source_state != active_state:
		return false
	if transition_lock_owner != null:
		return false
	else:
		transition_lock_owner = transition
		return true

func transition_unlock(transition : PLStateTransition) -> bool:
	if transition_lock_owner != transition:
		return false
	else:
		transition_lock_owner = null
		return true

func _state_entered(state : PLState):
	if active_state != null:
		push_warning("A state was entered when the StateMachine %s was not aware of a previous state being exited"%name)	
	active_state = state

func _state_exited(state : PLState):
	if active_state == state:
		active_state = null
	else:
		push_warning("A state was exited when the StateMachine %s was not aware of its previous activity"%name)

func _get_path_to_state(source_state : PLState, target_state : PLState) -> Array[PLStateTransition]:
	if !_states.has(target_state) or !_states.has(source_state):
		return []
	var visited = {}
	var next_transitions = []
	for trans in _states[source_state]:
		if trans.transition_disabled == false:
			next_transitions.push_back([0, trans, null])
	
	while(next_transitions.size() > 0):
		next_transitions.sort_custom(func(a, b) : return a[0] > b[0])
		var data = next_transitions.pop_back()
		var transition : PLStateTransition = data[1]
		var distance : int = data[0]
		visited[transition] = data
		
		#happy path
		if transition.target_state == target_state:
			var path : Array[PLStateTransition]
			while transition \
					and transition.source_state != source_state:
				path.push_back(transition)
				transition = visited[transition][2]
			path.push_back(transition)
			return path
		
		for next_transition in transition.connected_transitions:
			if (next_transition.transition_disabled == false) \
					and (!visited.has(next_transition) \
					or visited[next_transition][0] > distance + 1):
				next_transitions.push_back([distance + 1, next_transition, transition])
	return []

func _child_entered_tree(node : Node):
	if node is PLState:
		_states[node] = []
		node.child_entered_tree.connect(_state_child_entered_tree.bind(node))
		node.child_exiting_tree.connect(_state_child_exiting_tree.bind(node))
		node.exited_state.connect(_state_exited.bind(node))
		node.entered_state.connect(_state_entered.bind(node))

func _child_exiting_tree(node : Node):
	if node is PLState:
		_states.erase(node)
		if node.child_entered_tree.is_connected(_state_child_entered_tree):
			node.child_entered_tree.disconnect(_state_child_entered_tree)
		if node.child_exiting_tree.is_connected(_state_child_exiting_tree):
			node.child_exiting_tree.disconnect(_state_child_exiting_tree)
		if node.exited_state.is_connected(_state_exited):
			node.exited_state.disconnect(_state_exited)
		if node.entered_state.is_connected(_state_entered):
			node.exited_state.disconnect(_state_entered)

func _state_child_entered_tree(node : Node, state : PLState):
	if node is PLStateTransition and _states.has(state):
		if not _states[state].has(node):
			_states[state].push_back(node)
	
func _state_child_exiting_tree(node : Node, state : PLState):
	if node is PLStateTransition and _states.has(state):
		_states[state].erase(node)
