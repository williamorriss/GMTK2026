class_name ParticleController
extends CPUParticles2D

func _ready() -> void:
	emitting = true
	var _x: bool = finished.connect(queue_free)
