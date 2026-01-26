class_name PlayerBaseState extends State

var player_body: PlayerBody

func enter() -> void:
	player_body = character_body as PlayerBody

func physics_update(_delta: float) -> void:
	var movement_type = player_body.movement_component.get_movement_type()

	if not player_body.is_on_floor() and state_machine.current_state != JumpState and state_machine.current_state != ClimbState:
		state_machine.change_state("movement/fall")
	elif movement_type == "idle":
		state_machine.change_state("movement/idle")
	elif movement_type == "walk":
		state_machine.change_state("movement/walk")
	elif movement_type == "run":
		state_machine.change_state("movement/run")

	if not Input.is_action_pressed("run"):
		player_body.movement_component.change_speed(MovementComponent.MovementSpeed.WALK)
	elif Input.is_action_pressed("run"):
		player_body.movement_component.change_speed(MovementComponent.MovementSpeed.RUN)

# FIXME: when trying to climb using "move_left" or "move_right" it doesn't work.'
# Only really works with "move_forward"
func check_for_climbing() -> void:
	if player_body.upper_climb_check.is_colliding() and player_body.lower_climb_check.is_colliding():
		var direction_to_climbable = (player_body.upper_climb_check.get_collision_point() - player_body.position).normalized()

		var target_direction = Vector3(
			Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
			0,
			Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		)

		if target_direction.dot(direction_to_climbable) < -0.1:
			state_machine.change_state("movement/climb")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack"):
		state_machine.change_state("combat/attack/primary")
	elif event.is_action_pressed("secondary_attack"):
		state_machine.change_state("combat/attack/secondary")
	elif event.is_action_pressed("jump"):
		state_machine.change_state("movement/jump")
