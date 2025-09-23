class_name Player extends CharacterBody3D

@onready var movement_component: MovementComponent = $Components/MovementComponent

@onready var state_machine: StateMachine = $StateMachine

@onready var camera: Node3D = $Camera
@onready var yaw: Node3D = $Camera/Yaw

@onready var model: Node3D = $Model
@onready var animation_tree: AnimationTree = $Model/AnimationTree
@onready var animation_playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var current_state_label: Label = $CurrentState

var motion_enabled: bool = true
var target_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	state_machine.init(self)

func _process(delta: float) -> void:
	state_machine.update(delta)
	current_state_label.text = "STATE: " + state_machine.current_state.name.to_lower()

	target_direction = Vector3(
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
		0,
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	)

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	
	if motion_enabled:
		target_direction = target_direction.rotated(Vector3.UP, yaw.rotation.y)
	else:
		target_direction = Vector3.ZERO

	movement_component.change_direction(target_direction)

func _input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func disable_motion() -> void:
	motion_enabled = false
	movement_component.stop_moving()

func enable_motion() -> void:
	motion_enabled = true

func get_camera_forward() -> Vector3:
	return yaw.global_transform.basis.z

func get_camera_forward_horizontal() -> Vector3:
	var forward = get_camera_forward()
	forward.y = 0
	return forward

func face_camera_direction(delta: float) -> void:
	var camera_forward = get_camera_forward_horizontal()

	if camera_forward.length_squared() > 0.1:
		var target_angle = atan2(camera_forward.x, camera_forward.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, movement_component.model_rotation_speed * delta)
