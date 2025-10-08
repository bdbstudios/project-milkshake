class_name JumpState extends PlayerState

func enter() -> void:
	super()
	player.movement_component.do_jump()
	player.animation_component.play_jump()

func handle_input(_event: InputEvent) -> void:
	pass
