## The player character that extends CharacterBody3D.
##
## Coordinates between movement components to handle player input and movement physics.
class_name Player extends CharacterBody3D

## Reference to the MovementComponent that handles movement physics.
@onready var movement_component: MovementComponent = $Components/MovementComponent

## Reference to the MovementInputComponent that processes player input specific for movement.
@onready var movement_input_component: MovementInputComponent = $Components/MovementInputComponent

@onready var animation_tree: AnimationTree = $Model/AnimationTree

var is_in_air: bool = false

## Called when the node enters the scene tree.
## Connects signals from the input component to the movement component.
func _ready() -> void:
	movement_input_component.jump.connect(movement_component._on_jump_input)
	movement_input_component.speed_change.connect(movement_component._on_speed_change)
	movement_input_component.direction_change.connect(movement_component._on_direction_change)
	
	movement_input_component.jump.connect(_on_jump_input)

func _process(_delta: float) -> void:
	animation_tree.set("parameters/Movement/blend_position", movement_component.get_movement_state())

func _on_jump_input() -> void:
	animation_tree.set("parameters/conditions/jump", true)
