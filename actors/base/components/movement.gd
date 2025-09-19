class_name MovementComponent extends Node

@export var walking_speed: float = 5.0

@export var running_speed: float = 8.0

@export var acceleration: float = 10.0

@export var jump_force: float = 6.0

@export var model_reference: Node3D

@export var model_rotation_speed: float = 8.0

@export var max_air_jumps: int = 1

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction: Vector3 = Vector3.ZERO

var target_velocity: Vector3 = Vector3.ZERO

var jump_count: int = 0

var target_speed: float

enum MovementSpeed {
	WALK,
	RUN  
}

func _ready() -> void:
	assert(owner is CharacterBody3D, "Owner is not of type CharacterBody3D")
	assert(model_reference, "No model reference was assigned")

	target_speed = walking_speed

func _physics_process(delta: float) -> void:
	target_velocity.x = target_speed * direction.normalized().x
	target_velocity.z = target_speed * direction.normalized().z
	
	if not owner.is_on_floor():
		target_velocity.y -= gravity * delta
	else:
		jump_count = 0
	
	owner.velocity = owner.velocity.lerp(target_velocity, acceleration * delta)
	owner.move_and_slide()
	
	if direction.length() > 0:
		var movement_angle = atan2(direction.x, direction.z)
		model_reference.rotation.y = lerp_angle(model_reference.rotation.y, movement_angle, model_rotation_speed * delta)


func get_movement_state() -> String:
	var horizontal_velocity = Vector2(owner.velocity.x, owner.velocity.z)
	var speed = horizontal_velocity.length()

	if speed <= 0.2:
		return "idle"
	elif speed <= walking_speed:
		return "walk"
	else:
		return "run"

func _on_jump_input() -> void:
	if owner.is_on_floor() or jump_count < max_air_jumps:
		target_velocity.y = jump_force
		jump_count += 1

func _on_direction_change(new_direction: Vector3) -> void:
	direction = new_direction

func _on_speed_change(new_speed: MovementSpeed) -> void:
	match new_speed:
		MovementSpeed.RUN:
			target_speed = running_speed
		MovementSpeed.WALK:
			target_speed = walking_speed
		_:
			push_error("Unknown movement speed: ", new_speed)
