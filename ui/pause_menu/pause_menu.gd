class_name PauseMenu extends Control

@onready var resume_button: Button = $VBoxContainer/Resume
@onready var settings_button: Button = $VBoxContainer/Settings
@onready var exit_button: Button = $VBoxContainer/Exit

func _ready() -> void:
	resume_button.pressed.connect(on_resume_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	exit_button.pressed.connect(on_exit_pressed)

	resume_button.grab_focus()

func on_resume_pressed() -> void:
	# TODO: make a proper "Pause" funcionality (maybe in a global script?)
	self.visible = false

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func on_settings_pressed() -> void:
	print("Settings")

func on_exit_pressed() -> void:
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		# TODO: make a proper "Pause" funcionality (maybe in a global script?)
		self.visible = !self.visible

		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
