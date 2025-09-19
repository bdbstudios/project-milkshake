extends Node3D

@onready var YawNode: Node3D = $Yaw
@onready var PitchNode: Node3D = $Yaw/Pitch
@onready var CameraNode: Camera3D = $Yaw/Pitch/SpringArm3D/Camera3D

var yaw: float = 0
var pitch: float = 0

var yaw_sensitivity: float = 0.07
var pitch_sensitivity: float = 0.07

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var pitch_max: float = 75
var pitch_min: float = -55

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta: float) -> void:
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	YawNode.rotation_degrees.y = lerp(YawNode.rotation_degrees.y, yaw, yaw_acceleration * delta)
	PitchNode.rotation_degrees.x = lerp(PitchNode.rotation_degrees.x, pitch, pitch_acceleration * delta)
