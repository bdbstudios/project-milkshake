## A component that handles movement physics for a CharacterBody3D entity.
##
## Provides configurable movement parameters like speed, acceleration, and rotation.
## Handles gravity application and mesh rotation based on movement direction.
class_name MoveComponent extends Node

## The maximum movement speed of the entity.
@export var speed: float = 5.0

## The rate at which the entity accelerates to its target speed.
@export var acceleration: float = 10.0

## The root node of the mesh that should rotate to face the movement direction.
@export var mesh_root: Node3D

## The speed at which the mesh rotates to face the movement direction.
@export var mesh_rotation_speed: float = 8.0

## The gravity value retrieved from project settings.
var gravity: float

## The current movement direction in 3D space.
var direction: Vector3 = Vector3.ZERO

## The target velocity calculated from direction and speed.
var target_velocity: Vector3 = Vector3.ZERO

## Flag indicating if the entity is currently jumping.
var is_jumping: bool = false


## Called when the node enters the scene tree.
## Validates that the owner is a CharacterBody3D and that mesh_root is assigned.
func _ready() -> void:
	assert(owner is CharacterBody3D, "Owner is not of type CharacterBody3D")
	assert(mesh_root, "No mesh_root was assigned")
	
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


## Called every physics frame. Processes movement and applies gravity.
##
## @param delta: The time elapsed since the previous physics frame, in seconds.
func _physics_process(delta: float) -> void:
	# Calculate horizontal movement
	target_velocity.x = speed * direction.normalized().x
	target_velocity.z = speed * direction.normalized().z
	
	# Apply gravity if not on floor
	if not owner.is_on_floor():
		target_velocity.y -= gravity * delta
	
	# Apply movement with acceleration
	owner.velocity = owner.velocity.lerp(target_velocity, acceleration * delta)
	owner.move_and_slide()
	
	# Rotate mesh to face movement direction
	if direction.length() > 0:
		var movement_angle = atan2(direction.x, direction.z)
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, movement_angle, mesh_rotation_speed * delta)


## Checks if the entity is currently moving.
##
## @returns: True if the entity is moving in any horizontal direction, false otherwise.
func is_movement_happening() -> bool:
	return abs(direction.x) > 0 or abs(direction.z) > 0
