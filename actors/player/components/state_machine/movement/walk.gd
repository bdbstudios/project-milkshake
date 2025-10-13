class_name WalkState extends PlayerBaseState

func enter() -> void:
	super()
	player_body.animation_tree.set("parameters/GroundedTransition/transition_request", "grounded")
	player_body.animation_tree.set("parameters/MovementTransition/transition_request", "walk")
	# TODO: Implement "walk_backwards" animation with -1.0 on blend position
	player_body.animation_tree.set("parameters/WalkBlend/blend_position", 1.0)
