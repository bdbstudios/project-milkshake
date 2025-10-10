class_name PlayerBaseState extends State

var player: Player

func enter() -> void:
	player = character_body as Player

func physics_update(_delta: float) -> void:
	var movement_type = player.movement_component.get_movement_type()

	if not player.is_on_floor() and state_machine.current_state != JumpState:
		state_machine.change_state("movement/fall")
	elif movement_type == "idle":
		state_machine.change_state("movement/idle")
	elif movement_type == "walk":
		state_machine.change_state("movement/walk")
	elif movement_type == "run":
		state_machine.change_state("movement/run")

	if not Input.is_action_pressed("run"):
		player.movement_component.change_speed(MovementComponent.MovementSpeed.WALK)
	elif Input.is_action_pressed("run"):
		player.movement_component.change_speed(MovementComponent.MovementSpeed.RUN)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack"):
		state_machine.change_state("combat/attack/primary")
	elif event.is_action_pressed("secondary_attack"):
		state_machine.change_state("combat/attack/secondary")
	elif event.is_action_pressed("jump"):
		state_machine.change_state("movement/jump")
	elif event.is_action_pressed("transform"):
		state_machine.change_state("actions/transform")
