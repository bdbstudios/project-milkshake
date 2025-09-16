## The main player character that extends CharacterBody3D.
##
## Handles player movement, input processing, and camera control.
## Uses a component-based architecture with a MoveComponent for movement logic.
class_name Player extends CharacterBody3D

## Reference to the MoveComponent that handles movement physics.
@onready var move_component: MoveComponent = $Components/MoveComponent

## Reference to the Yaw node that controls horizontal camera rotation.
@onready var yaw: Node3D = $Camera/Yaw

## Array of move-related input actions detected from the InputMap.
var move_actions: Array = []

## The target movement direction calculated from input.
var target_direction: Vector3 = Vector3.ZERO


## Called when the node enters the scene tree.
## Detects all move-related input actions from the InputMap.
func _ready() -> void:
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("move_"):
			move_actions.append(action)


## Called every physics frame. Processes movement.
##
## @param delta: The time elapsed since the previous physics frame, in seconds.
func _physics_process(_delta: float) -> void:
	move_component.direction = target_direction.rotated(Vector3.UP, yaw.rotation.y)


## Processes unhandled input events.
##
## Detects movement input and updates the target direction accordingly.
##
## @param event: The input event to process.
func _unhandled_input(event: InputEvent) -> void:
	var move_action_detected = false
	
	# Check if the event is related to movement
	for action in move_actions:
		if event.is_action_pressed(action) or event.is_action_released(action):
			move_action_detected = true
			break

	if move_action_detected:
		# Calculate movement direction based on input axes
		target_direction = Vector3(
			Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
			0,
			Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		)
