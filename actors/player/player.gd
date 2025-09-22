class_name Player extends CharacterBody3D

@onready var movement_component: MovementComponent = $Components/MovementComponent

@onready var state_machine: StateMachine = $StateMachine

@onready var yaw: Node3D = $Camera/Yaw

@onready var animation_tree: AnimationTree = $Model/AnimationTree
@onready var animation_playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var current_state_label: Label = $CurrentState

var move_actions: Array = []
var target_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	state_machine.init(self)
	
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("move_"):
			move_actions.append(action)

func _process(delta: float) -> void:
	state_machine.update(delta)
	current_state_label.text = "STATE: " + state_machine.current_state.name.to_lower()

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	var move_action_detected = false
	
	for action in move_actions:
		if event.is_action_pressed(action) or event.is_action_released(action):
			move_action_detected = true
			break

	if move_action_detected:
		target_direction = Vector3(
			Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
			0,
			Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		)
		
	movement_component.change_direction(target_direction.rotated(Vector3.UP, yaw.rotation.y))
	state_machine.handle_input(event)
