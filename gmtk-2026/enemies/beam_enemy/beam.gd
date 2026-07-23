class_name Beam
extends Area2D

@export var lifetime: float

static func create_beam(direction: Vector2, pos: Vector2) -> Beam:
	var instance: Beam = preload("res://enemies/beam_enemy/beam.tscn").instantiate()
	instance.rotation = tan(direction.y / direction.x)
	instance.position = pos
	return instance

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
