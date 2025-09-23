class_name AttackState extends PlayerState

var attack_finished: bool = false
var should_replay: bool = false
	
func enter() -> void:
	super()
	player.disable_motion()

func physics_update(delta: float) -> void:
	player.face_camera_direction(delta)
	
	# TODO: Maybe validate the animation here? Or change depending on a timer instead?
	if player.animation_playback.get_current_length() == player.animation_playback.get_current_play_position():
		attack_finished = true
	else:
		attack_finished = false

func finish_attack() -> void:
	var movement_type = player.movement_component.get_movement_type()

	if movement_type == "idle":
		state_machine.change_state("idle")
	elif movement_type == "walk":
		state_machine.change_state("walk")
	elif movement_type == "run":
		state_machine.change_state("run")

# We override the handle_input from PlayerState so that it won't transition to a different attack state
# while holding down the attack button
func handle_input(_event: InputEvent) -> void:
	pass

func exit() -> void:
	player.enable_motion()
