class_name SplashScreenManager extends Control

@export var in_time: float = 0.5
@export var fade_in_time: float = 1.5
@export var pause_time: float = 1.5
@export var fade_out_time: float = 1.5
@export var out_time: float = 0.5
@export var next_scene: String = "res://world/levels/Safehouse.tscn"

@onready var splash_screen: TextureRect = $ColorRect/CenterContainer/TextureRect

func _ready() -> void:
	fade()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		#Global.game_controller.change_gui_scene(next_scene)
		get_tree().change_scene_to_file(next_scene)

func fade() -> void:
	splash_screen.modulate.a = 0.0
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(splash_screen, "modulate:a", 1.0, fade_in_time)
	tween.tween_interval(pause_time)
	tween.tween_property(splash_screen, "modulate:a", 0.0, fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished
	#Global.game_controller.change_gui_scene(next_scene)
	get_tree().change_scene_to_file(next_scene)
