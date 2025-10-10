class_name WalkState extends PlayerBaseState

func enter() -> void:
	super()
	player.animation_tree.set("parameters/GroundedTransition/transition_request", "grounded")
	player.animation_tree.set("parameters/MovementTransition/transition_request", "walk")
	# TODO: Implement "walk_backwards" animation with -1.0 on blend position
	player.animation_tree.set("parameters/WalkBlend/blend_position", 1.0)
