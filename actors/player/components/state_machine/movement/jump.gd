class_name JumpState extends PlayerBaseState

func enter() -> void:
	super()
	player_body.movement_component.do_jump()

func handle_input(_event: InputEvent) -> void:
	pass
