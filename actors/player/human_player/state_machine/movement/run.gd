class_name RunState extends PlayerBaseState

func enter() -> void:
	super()
	player.animation_tree.set("parameters/GroundedTransition/transition_request", "grounded")
	player.animation_tree.set("parameters/MovementTransition/transition_request", "run")
	# TODO: Implement "run_backwards" animation with -1.0 on blend position
	player.animation_tree.set("parameters/RunBlend/blend_position", 1.0)
