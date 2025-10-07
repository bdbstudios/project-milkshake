class_name TransformationComponent extends Node

@export var first_model: Node3D
@export var second_model: Node3D
@export var animation_tree: AnimationTree

@onready var current_model: Node3D = first_model

var first_model_animation_player: AnimationPlayer
var second_model_animation_player: AnimationPlayer

## "res://utils/effects/small_explosion/SmallExplosion.tscn"
const SMALL_EXPLOSION = preload("uid://ghn41tfsioqa")

func _ready() -> void:
	validate_models()
	first_model_animation_player = get_animation_player_or_null(first_model)
	second_model_animation_player = get_animation_player_or_null(second_model)

func transform() -> void:
	var transformation_effect = SMALL_EXPLOSION.instantiate()
	owner.add_child(transformation_effect)
	transformation_effect.position = Vector3(0, 1, 0)
	transformation_effect.trigger()

	if current_model == first_model:
		current_model = second_model
		first_model.visible = false
		second_model.visible = true
		animation_tree.anim_player = second_model_animation_player.get_path()
		owner.scale = Vector3(10, 10, 10)
		
	elif current_model == second_model:
		current_model = first_model
		first_model.visible = true
		second_model.visible = false
		animation_tree.anim_player = first_model_animation_player.get_path()
		owner.scale = Vector3(1, 1, 1)

func validate_models() -> void:
	assert(first_model, "No first model was provided")
	assert(second_model, "No second model was provided")
	assert(animation_tree, "No animation tree was provided")
	assert(get_animation_player_or_null(first_model), "First model does not have an AnimationPlayer child")
	assert(get_animation_player_or_null(second_model), "Second model does not have an AnimationPlayer child")

func get_animation_player_or_null(model: Node3D) -> AnimationPlayer:
	var animation_player = null

	for child in model.get_children():
		if child is AnimationPlayer:
			animation_player = child
	
	return animation_player
