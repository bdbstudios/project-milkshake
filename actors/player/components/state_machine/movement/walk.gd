class_name WalkState extends PlayerBaseState

func enter() -> void:
	super()
	player_body.animation_tree.set("parameters/FallingTransition/transition_request", "not_falling")
	player_body.animation_tree.set("parameters/MovementTransition/transition_request", "walk")
	# TODO: Implement "walk_backwards" animation with -1.0 on blend position
	player_body.animation_tree.set("parameters/WalkBlend/blend_position", 1.0)

func physics_update(delta: float) -> void:
	super(delta)
	check_for_climbing()
