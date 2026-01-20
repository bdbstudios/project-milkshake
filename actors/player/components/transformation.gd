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
