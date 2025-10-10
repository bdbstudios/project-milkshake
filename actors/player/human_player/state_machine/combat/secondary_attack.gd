class_name SecondaryAttackState extends AttackState

func _ready() -> void:
	animation_parameter_name = "parameters/PunchRightOneShot/request"
	input_name = "secondary_attack"

func enter() -> void:
	super()
	player.hitbox_component.damage_amount = 100
