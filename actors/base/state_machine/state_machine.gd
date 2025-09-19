class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary[String, State] = {}

func init(character_body: CharacterBody3D) -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			child.character_body = character_body
			states[child.name.to_lower()] = child

	assert(initial_state, "No initial state was assigned")

	initial_state.enter()
	current_state = initial_state

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	
	assert(new_state, "State not found: " + new_state_name)
	
	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
