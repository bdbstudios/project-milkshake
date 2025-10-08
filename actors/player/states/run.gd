class_name RunState extends PlayerState

func enter() -> void:
	super()
	player.animation_component.play_run()
