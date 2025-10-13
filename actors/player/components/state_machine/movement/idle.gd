class_name IdleState extends PlayerBaseState

func enter() -> void:
	super()
	player_body.animation_tree.set("parameters/GroundedTransition/transition_request", "grounded")
	player_body.animation_tree.set("parameters/MovementTransition/transition_request", "idle")
