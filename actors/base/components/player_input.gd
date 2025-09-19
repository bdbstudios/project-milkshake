class_name PlayerInputComponent extends Node

signal jump()

signal direction_change(new_direction: Vector3)

signal run()

var move_actions: Array = []

var target_direction: Vector3 = Vector3.ZERO


func _ready() -> void:
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("move_"):
			move_actions.append(action)


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
		
	direction_change.emit(target_direction)

	if event.is_action_pressed("jump"):
		jump.emit()

	if event.is_action_pressed("run"):
		run.emit()
