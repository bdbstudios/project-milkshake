class_name IdleState extends PlayerBaseState

func enter() -> void:
	super()
	player_body.animation_tree.set("parameters/FallingTransition/transition_request", "not_falling")
	player_body.animation_tree.set("parameters/ClimbingTransition/transition_request", "not_climbing")
	player_body.animation_tree.set("parameters/MovementTransition/transition_request", "idle")
