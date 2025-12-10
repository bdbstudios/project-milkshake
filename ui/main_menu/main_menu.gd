class_name MainMenu extends Control

@onready var play_button: Button = $VBoxContainer/Play
@onready var settings_button: Button = $VBoxContainer/Settings
@onready var exit_button: Button = $VBoxContainer/Exit

func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	exit_button.pressed.connect(on_exit_pressed)

	play_button.grab_focus()

func on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://world/levels/Safehouse.tscn")

func on_settings_pressed() -> void:
	print("Settings")

func on_exit_pressed() -> void:
	get_tree().quit()
