class_name IdleState extends PlayerState

func enter() -> void:
	super()
	player.animation_component.play_idle()
