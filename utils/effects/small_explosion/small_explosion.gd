class_name SmallExplosion extends Node3D

@onready var smoke: GPUParticles3D = $Smoke
@onready var glow: GPUParticles3D = $Glow

# TODO: add a sound as export
# TODO: add glow color as export
# TODO: add timer as export?

func trigger() -> void:
	smoke.emitting = true
	glow.emitting = true

	var timer = get_tree().create_timer(2)
	timer.timeout.connect(queue_free)
