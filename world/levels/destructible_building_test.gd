class_name DestructibleBuilding extends Node3D

@onready var destructible_building: DestructibleBuilding = $"."

@onready var voronoi_shatter: VoronoiShatter = $VoronoiShatter
@onready var mesh_instance: MeshInstance3D = $VoronoiShatter/Building
@onready var static_body_3d: StaticBody3D = $VoronoiShatter/Building/StaticBody3D
@onready var area_3d: Area3D = $VoronoiShatter/Building/Area3D
@onready var fractured_mesh_instance: VoronoiCollection = $VoronoiShatter/Fractured_Building_5349633

@onready var player: Player = $"../Player"

@export var piece_lifetime: float = 10.0

func _ready() -> void:
	freeze_meshes()
	area_3d.area_entered.connect(_on_hitbox_enter)
	fractured_mesh_instance.visible = false

func _on_hitbox_enter(_area: Area3D) -> void:
	destroy_building()

func freeze_meshes() -> void:
	for child in fractured_mesh_instance.get_children():
		if child is RigidBody3D:
			child.freeze = true

func unfreeze_meshes() -> void:
	for child in fractured_mesh_instance.get_children():
		if child is RigidBody3D:
			child.freeze = false

func destroy_building() -> void:
	mesh_instance.queue_free()
	fractured_mesh_instance.visible = true

	for child in fractured_mesh_instance.get_children():
		if child is RigidBody3D:
			child.freeze = false

			var direction = (child.global_position - player.global_position).normalized()
			child.apply_impulse(direction * 5 + Vector3.UP * 20 * 0.5)

			var timer = child.get_tree().create_timer(piece_lifetime)
			timer.timeout.connect(child.queue_free)
