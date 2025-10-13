class_name Player extends Node3D

@export var health_component: HealthComponent
@export var transformation_component: TransformationComponent

@onready var camera: CameraComponent = $Camera

func _ready() -> void:
	assert(health_component, "No health component was provided")
	assert(transformation_component, "No transformation component was provided")
	
	Global.player = self
	Global.active_camera = camera

func _physics_process(_delta: float) -> void:
	if transformation_component.current_body:
		self.global_transform = transformation_component.current_body.global_transform

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("transform"):
		transformation_component.transform()
