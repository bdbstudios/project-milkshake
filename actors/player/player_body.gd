@abstract
class_name PlayerBody extends CharacterBody3D

@export var movement_component: MovementComponent

@export var hitbox_component: HitboxComponent
@export var hitbox_collision: CollisionShape3D

@export var state_machine: PlayerStateMachine

@export var model: Node3D
@export var animation_tree: AnimationTree

@export var camera_height: float = 1.0
@export var camera_zoom: float = 2.0

var motion_enabled: bool = true
var target_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	state_machine.init(self)
	validate_exports()

func validate_exports() -> void:
	assert(movement_component, "No movement component was provided")

	assert(hitbox_component, "No hitbox component was provided")
	assert(hitbox_collision, "No hitbox collision shape was provided")

	assert(state_machine, "No state machine component was provided")

	assert(model, "No model component was provided")
	assert(animation_tree, "No animation tree component was provided")

func _process(delta: float) -> void:
	state_machine.update(delta)

	target_direction = Vector3(
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
		0,
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	)

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	
	if motion_enabled:
		target_direction = target_direction.rotated(Vector3.UP, Global.active_camera.YawNode.rotation.y)
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

func face_camera_direction(delta: float) -> void:
	var camera_forward = Global.active_camera.YawNode.global_transform.basis.z
	camera_forward.y = 0

	if camera_forward.length_squared() > 0.1:
		var target_angle = atan2(camera_forward.x, camera_forward.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, movement_component.model_rotation_speed * delta)
