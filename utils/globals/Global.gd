extends Node

var player: Player
var active_camera: CameraComponent
#var game_controller: GameController

var current_scene: Node = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func change_scene(path: String):
	var error = get_tree().change_scene_to_file(path)
	if error != OK:
		push_error("Failed to change scene: " + str(error))
