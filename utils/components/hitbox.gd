class_name HitboxComponent extends Area3D

# TODO: make this more modular, this shouldn't be part of the hitbox but the weapon used?
# or maybe the implementation should be that hitbox is only applied to the weapon, not the actor?
# what about the hurtbox? what would it do?
@export var damage_amount: int = 10

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	var area_health_component = area.owner.get_node_or_null("Components/HealthComponent") as HealthComponent

	if area_health_component:
		area_health_component.take_damage(damage_amount)
