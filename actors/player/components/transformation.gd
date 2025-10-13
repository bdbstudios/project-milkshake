class_name TransformationComponent extends Node

var current_body: PlayerBody

const HUMAN_BODY = preload("uid://b42wo4b8k4jk8")
const MONSTER_BODY = preload("uid://crpci0bdnjncy")
const SMALL_EXPLOSION = preload("uid://ghn41tfsioqa")

func _ready() -> void:
	instantiate_new_body(HUMAN_BODY)

func transform() -> void:
	var transformation_effect = SMALL_EXPLOSION.instantiate()
	add_child(transformation_effect)

	if current_body is HumanBody:
		instantiate_new_body(MONSTER_BODY)
		transformation_effect.global_transform = current_body.global_transform
		transformation_effect.position.y = current_body.camera_height
	elif current_body is MonsterBody:
		instantiate_new_body(HUMAN_BODY)
		transformation_effect.global_transform = current_body.global_transform
		transformation_effect.position.y = current_body.camera_height

	transformation_effect.trigger()

func instantiate_new_body(player_body: PackedScene) -> void:
	var new_body = player_body.instantiate()
	add_child(new_body)

	if current_body:
		new_body.global_transform = current_body.global_transform
		new_body.model.rotation = current_body.model.rotation
		current_body.queue_free()

	if Global.active_camera:
		Global.active_camera.position.y = new_body.camera_height
		Global.active_camera.initial_zoom_length = new_body.camera_zoom
		Global.active_camera.reset_zoom()

	current_body = new_body

# TODO: figure out how to make this work? or add it to player script?

#
#@export var first_model: PackedScene
#@export var second_model: PackedScene
#
#@onready var current_model: PackedScene = first_model
#
### "res://utils/effects/small_explosion/SmallExplosion.tscn"
#const SMALL_EXPLOSION = preload("uid://ghn41tfsioqa")
#
#func _ready() -> void:
	#assert(first_model, "No first model was provided")
	#assert(second_model, "No second model was provided")
#
#func transform() -> void:
	#var transformation_effect = SMALL_EXPLOSION.instantiate()
	#owner.add_child(transformation_effect)
	#transformation_effect.position = first_model.position
	#transformation_effect.trigger()
#
	#if current_model == first_model:
		#current_model = second_model
		#first_model.visible = false
		#second_model.visible = true
		#owner.scale = Vector3(10, 10, 10)
	#elif current_model == second_model:
		#current_model = first_model
		#first_model.visible = true
		#second_model.visible = false
		#owner.scale = Vector3(1, 1, 1)
