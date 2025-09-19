class_name Player extends CharacterBody3D

@onready var movement_component: MovementComponent = $Components/MovementComponent

@onready var player_input_component: PlayerInputComponent = $Components/PlayerInputComponent

@onready var state_machine: StateMachine = $StateMachine

@onready var yaw: Node3D = $Camera/Yaw

@onready var animation_tree: AnimationTree = $Model/AnimationTree
@onready var animation_playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var current_state_label: Label = $CurrentState

func _ready() -> void:
	state_machine.init(self)
	
	print(animation_playback)
	
	player_input_component.direction_change.connect(_on_direction_change)
	player_input_component.jump.connect(_on_jump_input)

func _process(delta: float) -> void:
	state_machine.update(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	
	#	TODO: Fix the state machine changing states all the time
	#	it should not change state to "Walk" when "Jump" is happening for example
	state_machine.change_state(movement_component.get_movement_state())
	current_state_label.text = "STATE: " + state_machine.current_state.name.to_lower()

func _on_direction_change(new_direction: Vector3) -> void:
	movement_component._on_direction_change(new_direction.rotated(Vector3.UP, yaw.rotation.y))

func _on_jump_input() -> void:
	movement_component._on_jump_input()

	state_machine.change_state("jump")
