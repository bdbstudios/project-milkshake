extends AttackState

func enter() -> void:
	super()
	# TODO: maybe make player look at where camera is facing?
	player.animation_playback.travel("Primary_Attack")

func update(delta: float) -> void:
	super(delta)

	if Input.is_action_pressed("primary_attack"):
		should_replay = true
	else:
		should_replay = false

func physics_update(delta: float) -> void:
	super(delta)
	
	if attack_finished:
		if should_replay:
			player.animation_playback.start("Primary_Attack", true)
		else:
			finish_attack()
