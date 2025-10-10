class_name IdleState extends PlayerBaseState

func enter() -> void:
	super()
	player.animation_tree.set("parameters/GroundedTransition/transition_request", "grounded")
	player.animation_tree.set("parameters/MovementTransition/transition_request", "idle")
