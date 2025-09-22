extends PlayerState

func enter() -> void:
	super()
	player.animation_playback.travel("Jump")

# Jump state has a different logic for changing states. Can only change if player.is_on_floor()
func physics_update(_delta: float) -> void:
	# Do not call super() here, it will override the logic for changing states
	if player.is_on_floor():
		var movement_type = player.movement_component.get_movement_type()
		
		if movement_type == "idle":
			state_machine.change_state("idle")
		elif movement_type == "walk":
			state_machine.change_state("walk")
		elif movement_type == "run":
			state_machine.change_state("run")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		player.movement_component.do_jump()
