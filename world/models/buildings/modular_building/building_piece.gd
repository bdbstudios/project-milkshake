class_name BuildingPiece extends Node3D


@export var piece_lifetime: float = 5.0
@export var mesh_instance: MeshInstance3D
@export var level_above_raycast: RayCast3D
@export var voronoi_shatter: VoronoiShatter
@export var voronoi_collection: VoronoiCollection

@onready var health_component: HealthComponent = $Components/HealthComponent

func _ready() -> void:
	auto_assign_nodes()

	assert(mesh_instance, "No mesh instance was assigned")
	assert(voronoi_shatter, "No voronoi shatter was assigned")
	assert(voronoi_collection, "No voronoi collection was assigned")

	freeze_meshes()
	voronoi_collection.visible = false
	
	health_component.health_depleted.connect(destroy_building)
	
func auto_assign_nodes() -> void:
	if mesh_instance and voronoi_shatter and voronoi_collection:
		print("Nodes already assigned, skipping auto-assign")
		return

	for child in get_children():
		if child is VoronoiShatter:
			voronoi_shatter = child

	if not voronoi_shatter:
		return

	for child in voronoi_shatter.get_children():
		if child is VoronoiCollection:
			voronoi_collection = child
		elif child is MeshInstance3D:
			mesh_instance = child

func freeze_meshes() -> void:
	for child in voronoi_collection.get_children():
		if child is RigidBody3D:
			child.freeze = true

func unfreeze_meshes() -> void:
	for child in voronoi_collection.get_children():
		if child is RigidBody3D:
			child.freeze = false

func destroy_building() -> void:
	mesh_instance.queue_free()
	voronoi_collection.visible = true
	
	if level_above_raycast:
		propagate_destruction_above()

	for child in voronoi_collection.get_children():
		if child is RigidBody3D:
			child.freeze = false
			
			# Debris layer
			# TODO: Maybe handle layer changing on a Global script thing
			child.collision_layer = 8

			var direction = (child.global_position).normalized()
			child.apply_impulse(direction * 5 + Vector3.UP * 20 * 0.5)

			var timer = get_tree().create_timer(piece_lifetime)
			timer.timeout.connect(queue_free)

func propagate_destruction_above() -> void:
	level_above_raycast.enabled = true
	level_above_raycast.collide_with_areas = true
	level_above_raycast.collide_with_bodies = false

	var level_above = level_above_raycast.get_collider()

	if level_above and level_above.owner.has_method("destroy_building"):
		level_above.owner.destroy_building()
