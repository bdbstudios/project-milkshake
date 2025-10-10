class_name EnemyOfficer extends CharacterBody3D

@onready var health_component: HealthComponent = $Components/HealthComponent

@onready var animation_tree: AnimationTree = $Model/AnimationTree
@onready var animation_player: AnimationPlayer = $"Model/character-male-c/AnimationPlayer"

func _ready() -> void:
	health_component.health_depleted.connect(_on_health_depleted)

func _on_health_depleted() -> void:
	# TODO: fix this by making a more advanced animation tree and using that
	# instead of directly playing an animation
	animation_tree.active = false
	animation_player.play("die")
