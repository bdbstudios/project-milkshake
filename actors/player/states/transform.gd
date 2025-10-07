extends PlayerState

func enter() -> void:
	super()
	player.disable_motion()
	player.animation_playback.travel("Idle")
	player.transformation_component.transform()

	# TODO: make an animation play for transformation and wait for it to finish instead of a timer
	var timer = get_tree().create_timer(.5)
	timer.timeout.connect(finish_transformation)

# We override the handle_input from PlayerState so that it won't transition to a different state
# while transforming
func physics_update(_delta: float) -> void:
	pass

# We override the handle_input from PlayerState so that it won't transition to a different state
# while transforming
func handle_input(_event: InputEvent) -> void:
	pass

func finish_transformation() -> void:
	var movement_type = player.movement_component.get_movement_type()

	if movement_type == "idle":
		state_machine.change_state("idle")
	elif movement_type == "walk":
		state_machine.change_state("walk")
	elif movement_type == "run":
		state_machine.change_state("run")

func exit() -> void:
	player.enable_motion()
