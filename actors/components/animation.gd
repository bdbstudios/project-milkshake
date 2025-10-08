class_name AnimationComponent extends Node

@export var animation_tree: AnimationTree
@export var blend_speed: float = 10.0

var current_grounded_blend: float = 1.0
var target_grounded_blend: float = 1.0

func _ready() -> void:
	assert(animation_tree, "No AnimationTree was provided")
	play_idle()

func _process(delta: float) -> void:
	update_grounded_blend_target(delta)

func update_grounded_blend_target(delta: float) -> void:
	current_grounded_blend = lerpf(current_grounded_blend, target_grounded_blend, blend_speed * delta)
	animation_tree.set("parameters/GroundedBlend/blend_amount", current_grounded_blend)

func play_idle() -> void:
	target_grounded_blend = 1.0
	animation_tree.set("parameters/MovementTransition/transition_request", "idle")

func play_walk(direction: float = 1.0) -> void:
	target_grounded_blend = 1.0
	animation_tree.set("parameters/MovementTransition/transition_request", "walk")
	animation_tree.set("parameters/WalkBlend/blend_position", direction)

func play_run(direction: float = 1.0) -> void:
	target_grounded_blend = 1.0
	animation_tree.set("parameters/MovementTransition/transition_request", "run")
	animation_tree.set("parameters/RunBlend/blend_position", direction)

func set_movement_time_scale(time_scale: float) -> void:
	animation_tree.set("parameters/MovementTimeScale/scale", time_scale)

func play_fall() -> void:
	target_grounded_blend = 0.0

func play_jump() -> void:
	animation_tree.set("parameters/JumpOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
