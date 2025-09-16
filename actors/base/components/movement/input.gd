## A component that handles movement input processing for a character.
##
## Translates input events into movement signals for other components to handle.
## Supports directional movement, jumping, and speed changes (walk/run).
class_name MovementInputComponent extends Node

## Emitted when a jump input is detected.
signal jump()

## Emitted when a speed change input is detected.
##
## @param new_speed: The new movement speed from the MovementComponent.MovementSpeed enum.
signal speed_change(new_speed: MovementComponent.MovementSpeed)

## Emitted when the movement direction changes.
##
## @param new_direction: The new movement direction as a Vector3.
signal direction_change(new_direction: Vector3)

## Reference to the Yaw node that provides horizontal rotation reference for direction calculation.
@export var yaw_reference: Node3D

## Array of move-related input actions detected from the InputMap.
var move_actions: Array = []

## The target movement direction calculated from input before rotation adjustment.
var target_direction: Vector3 = Vector3.ZERO


## Called when the node enters the scene tree.
## Validates that yaw_reference is assigned and detects move-related input actions.
func _ready() -> void:
	assert(yaw_reference, "No yaw reference was assigned")
	
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("move_"):
			move_actions.append(action)


## Processes unhandled input events.
##
## Detects movement, jump, and speed change inputs, and emits appropriate signals.
##
## @param event: The input event to process.
func _unhandled_input(event: InputEvent) -> void:
	var move_action_detected = false
	
	# Check if the event is related to movement
	for action in move_actions:
		if event.is_action_pressed(action) or event.is_action_released(action):
			move_action_detected = true
			break

	# Update target direction if movement input changed
	if move_action_detected:
		target_direction = Vector3(
			Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
			0,
			Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		)

	# Emit rotated direction based on yaw reference
	direction_change.emit(target_direction.rotated(Vector3.UP, yaw_reference.rotation.y))

	# Handle jump input
	if event.is_action_pressed("jump"):
		jump.emit()
	
	# Handle speed change input (run/walk)
	if event.is_action_pressed("run"):
		speed_change.emit(MovementComponent.MovementSpeed.RUN)
	elif event.is_action_released("run"):
		speed_change.emit(MovementComponent.MovementSpeed.WALK)
