class_name SecondaryAttackState extends AttackState

func enter() -> void:
	super()
	#player.animation_playback.travel("Secondary_Attack")
	player.hitbox_component.damage_amount = 100

func update(delta: float) -> void:
	super(delta)

	if Input.is_action_pressed("secondary_attack"):
		should_replay = true
	else:
		should_replay = false

func physics_update(delta: float) -> void:
	super(delta)

	if attack_finished:
		if should_replay:
			player.animation_playback.start("Secondary_Attack", true)
		else:
			finish_attack()
