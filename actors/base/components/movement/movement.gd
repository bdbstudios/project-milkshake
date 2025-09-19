## A component that handles movement physics for a CharacterBody3D entity.
##
## Provides configurable movement parameters like speed, acceleration, and rotation.
## Handles gravity application and mesh rotation based on movement direction.
class_name MovementComponent extends Node

## The movement speed when walking.
@export var walking_speed: float = 5.0

## The movement speed when running.
@export var running_speed: float = 8.0

## The rate at which the entity accelerates to its target speed.
@export var acceleration: float = 10.0

## The vertical force applied when jumping.
@export var jump_force: float = 6.0

## The root node of the mesh that should rotate to face the movement direction.
@export var model_reference: Node3D

## The speed at which the mesh rotates to face the movement direction.
@export var model_rotation_speed: float = 8.0

## The gravity value retrieved from project settings.
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

## The current movement direction in 3D space.
var direction: Vector3 = Vector3.ZERO

## The target velocity calculated from direction and speed.
var target_velocity: Vector3 = Vector3.ZERO

## The maximum number of air jumps allowed.
var max_air_jumps: int = 1

## The current count of jumps performed while in the air.
var jump_count: int = 0

## The current target speed (walking or running).
var target_speed: float

## Enum defining different movement speeds.
enum MovementSpeed {
	WALK,  ## Walking speed
	RUN    ## Running speed
}


## Called when the node enters the scene tree.
## Validates that the owner is a CharacterBody3D and that model_reference is assigned.
func _ready() -> void:
	assert(owner is CharacterBody3D, "Owner is not of type CharacterBody3D")
	assert(model_reference, "No model reference was assigned")

	target_speed = walking_speed


## Called every physics frame. Processes movement and applies gravity.
##
## @param delta: The time elapsed since the previous physics frame, in seconds.
func _physics_process(delta: float) -> void:
	# Calculate horizontal movement
	target_velocity.x = target_speed * direction.normalized().x
	target_velocity.z = target_speed * direction.normalized().z
	
	# Apply gravity if not on floor
	if not owner.is_on_floor():
		target_velocity.y -= gravity * delta
	else:
		jump_count = 0
	
	# Apply movement with acceleration
	owner.velocity = owner.velocity.lerp(target_velocity, acceleration * delta)
	owner.move_and_slide()
	
	# Rotate mesh to face movement direction
	if direction.length() > 0:
		var movement_angle = atan2(direction.x, direction.z)
		model_reference.rotation.y = lerp_angle(model_reference.rotation.y, movement_angle, model_rotation_speed * delta)


## Calculates the current movement state based on velocity.
##
## Returns a value between -1 and 1 where:
##   -1: idle
##    0: walking
##    1: running
##
## @returns: A float representing the movement state.
func get_movement_state() -> float:
	# Get horizontal velocity (ignore vertical movement)
	var horizontal_velocity = Vector2(owner.velocity.x, owner.velocity.z)
	var speed = horizontal_velocity.length()

	# Normalize speed relative to walking and running speeds
	if speed <= 0.1:  # Small threshold to account for floating point imprecision
		return -1.0  # Idle
	elif speed <= walking_speed:
		# Map from [0.1, walking_speed] to [-1, 0]
		return remap(speed, 0.1, walking_speed, -1.0, 0.0)
	else:
		# Map from [walking_speed, running_speed] to [0, 0.6]
		return remap(speed, walking_speed, running_speed, 0.0, 1.0)


## Handles jump input by applying vertical force.
func _on_jump_input() -> void:
	if owner.is_on_floor() or jump_count < max_air_jumps:
		target_velocity.y = jump_force
		jump_count += 1


## Updates the movement direction based on input.
##
## @param new_direction: The new movement direction as a Vector3.
func _on_direction_change(new_direction: Vector3) -> void:
	direction = new_direction


## Changes the movement speed based on the specified speed type.
##
## @param new_speed: The new movement speed from the MovementSpeed enum.
func _on_speed_change(new_speed: MovementSpeed) -> void:
	match new_speed:
		MovementSpeed.RUN:
			target_speed = running_speed
		MovementSpeed.WALK:
			target_speed = walking_speed
		_:
			push_error("Unknown movement speed: ", new_speed)
