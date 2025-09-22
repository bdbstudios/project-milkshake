class_name PlayerState extends State

var player: Player

func enter() -> void:
	player = character_body as Player
	
func physics_update(_delta: float) -> void:
	var movement_type = player.movement_component.get_movement_type()
	
	if not player.is_on_floor():
		state_machine.change_state("jump")
	elif movement_type == "idle":
		state_machine.change_state("idle")
	elif movement_type == "walk":
		state_machine.change_state("walk")
	elif movement_type == "run":
		state_machine.change_state("run")

	if not Input.is_action_pressed("run"):
		player.movement_component.change_speed(MovementComponent.MovementSpeed.WALK)
	elif Input.is_action_pressed("run"):
		player.movement_component.change_speed(MovementComponent.MovementSpeed.RUN)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("light_attack"):
		state_machine.change_state("light_attack")
	elif event.is_action_pressed("heavy_attack"):
		state_machine.change_state("heavy_attack")
	elif event.is_action_pressed("jump"):
		player.movement_component.do_jump()
