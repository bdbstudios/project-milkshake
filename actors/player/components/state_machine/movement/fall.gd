class_name FallState extends PlayerBaseState

func enter() -> void:
	super()
	player_body.animation_tree.set("parameters/GroundedTransition/transition_request", "falling")

# Fall state has a different logic for changing states. Can only change if player_body.is_on_floor()
func physics_update(_delta: float) -> void:
	# Do not call super() here, it will override the logic for changing states
	if player_body.is_on_floor():
		var movement_type = player_body.movement_component.get_movement_type()

		if movement_type == "idle":
			state_machine.change_state("movement/idle")
		elif movement_type == "walk":
			state_machine.change_state("movement/walk")
		elif movement_type == "run":
			state_machine.change_state("movement/run")

# Overriding this method ensures that inputs listed on PlayerState are not listed on this State
# This essentially makes it so that the player_body cannot attack while in the air for example
func handle_input(_event: InputEvent) -> void:
	pass
