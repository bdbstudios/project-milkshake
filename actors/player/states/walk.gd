class_name WalkState extends PlayerState

func enter() -> void:
	super()
	player.animation_component.play_walk()
