class_name GameController extends Node

@export var world_3d: Node3D
@export var world_2d: Node2D
@export var gui: Control

var current_world_3d_scene: Node3D
var current_world_2d_scene: Node2D
var current_gui_scene: Control

func _ready() -> void:
	Global.game_controller = self

func change_gui_scene(scene_name: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)

	var new_scene = load(scene_name).instantiate()
	gui.add_child(new_scene)
	current_gui_scene = new_scene

func change_world_2d_scene(scene_name: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_world_2d_scene != null:
		if delete:
			current_world_2d_scene.queue_free()
		elif keep_running:
			current_world_2d_scene.visible = false
		else:
			world_2d.remove_child(current_world_2d_scene)

	var new_scene = load(scene_name).instantiate()
	world_2d.add_child(new_scene)
	current_world_2d_scene = new_scene
	
func change_world_3d_scene(scene_name: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_world_3d_scene != null:
		if delete:
			current_world_3d_scene.queue_free()
		elif keep_running:
			current_world_3d_scene.visible = false
		else:
			world_3d.remove_child(current_world_3d_scene)

	var new_scene = load(scene_name).instantiate()
	world_3d.add_child(new_scene)
	current_world_3d_scene = new_scene
