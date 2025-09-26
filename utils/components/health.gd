class_name HealthComponent extends Node

signal health_depleted

@export var max_health: int = 100

@onready var current_health: int = max_health

func take_damage(amount: int) -> void:
	if current_health <= 0:
		return
	
	current_health -= amount

	if current_health <= 0:
		die()

func restore_health(amount: int) -> void:
	current_health += amount

	if current_health > max_health:
		current_health = max_health

func die() -> void:
	health_depleted.emit()
