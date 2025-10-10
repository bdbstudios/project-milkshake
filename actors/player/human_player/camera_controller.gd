extends Node3D

# TODO: refactor this controller (maybe put it into player script?)
# TODO: add a global script to handle if input should be enabled or not

@onready var YawNode: Node3D = $Yaw
@onready var PitchNode: Node3D = $Yaw/Pitch
@onready var SpringArmNode: SpringArm3D = $Yaw/Pitch/SpringArm3D
@onready var CameraNode: Camera3D = $Yaw/Pitch/SpringArm3D/Camera3D

@export_category("Camera Zoom Settings")
@export var initial_zoom_length: float = 2.5
@export var min_zoom_length: float = 1.0
@export var max_zoom_length: float = 7.0
@export var zoom_speed: float = 5.0
@export var zoom_step: float = 1.0

var yaw: float = 0
var pitch: float = 0

var yaw_sensitivity: float = 0.07
var pitch_sensitivity: float = 0.07

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var pitch_max: float = 75
var pitch_min: float = -55

var target_zoom_length: float
var is_zooming: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	target_zoom_length = SpringArmNode.spring_length
	target_zoom_length = clamp(target_zoom_length, min_zoom_length, max_zoom_length)
	SpringArmNode.spring_length = target_zoom_length
	
	reset_zoom()

func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			yaw += -event.relative.x * yaw_sensitivity
			pitch += event.relative.y * pitch_sensitivity

	if event.is_action_pressed("pause_menu"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event.is_action_pressed("zoom_in"):
		zoom_in()
	elif event.is_action_pressed("zoom_out"):
		zoom_out()
	elif event.is_action_pressed("zoom_reset"):
		reset_zoom()

func _process(delta: float) -> void:
	if not is_equal_approx(SpringArmNode.spring_length, target_zoom_length):
		SpringArmNode.spring_length = lerp(SpringArmNode.spring_length, target_zoom_length, zoom_speed * delta)

		if abs(SpringArmNode.spring_length - target_zoom_length) < 0.01:
			SpringArmNode.spring_length = target_zoom_length

func _physics_process(delta: float) -> void:
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	YawNode.rotation_degrees.y = lerp(YawNode.rotation_degrees.y, yaw, yaw_acceleration * delta)
	PitchNode.rotation_degrees.x = lerp(PitchNode.rotation_degrees.x, pitch, pitch_acceleration * delta)

func zoom_in():
	target_zoom_length = clamp(target_zoom_length - zoom_step, min_zoom_length, max_zoom_length)

func zoom_out():
	target_zoom_length = clamp(target_zoom_length + zoom_step, min_zoom_length, max_zoom_length)

func set_zoom_level(normalized_value: float) -> void:
	target_zoom_length = lerp(min_zoom_length, max_zoom_length, normalized_value)

func get_zoom_normalized() -> float:
	return inverse_lerp(min_zoom_length, max_zoom_length, SpringArmNode.spring_length)

func reset_zoom() -> void:
	target_zoom_length = initial_zoom_length
