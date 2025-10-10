class_name PrimaryAttackState extends AttackState

func _ready() -> void:
	animation_parameter_name = "parameters/PunchLeftOneShot/request"
	input_name = "primary_attack"

func enter() -> void:
	super()
	player.hitbox_component.damage_amount = 100
