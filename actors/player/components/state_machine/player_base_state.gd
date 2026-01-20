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

	if player_body.climb_check_up.is_colliding() and player_body.climb_check_down.is_colliding():
		state_machine.change_state("movement/climb")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack"):
		state_machine.change_state("combat/attack/primary")
	elif event.is_action_pressed("secondary_attack"):
		state_machine.change_state("combat/attack/secondary")
	elif event.is_action_pressed("jump"):
		state_machine.change_state("movement/jump")
