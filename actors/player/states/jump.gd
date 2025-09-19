extends PlayerState

func enter() -> void:
	super()
	player.animation_playback.travel("Jump")
