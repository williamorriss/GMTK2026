extends Node

@onready var burst_scene: PackedScene = preload("res://blood/blood.tscn")
@onready var splatter_scene: PackedScene = preload("res://blood/blood_splatter.tscn")
@export var max_splatters: int = 150

var splatters: Array[Node2D] = []

func burst(direction: Vector2, origin: Vector2) -> void:
	var b = burst_scene.instantiate()
	get_tree().current_scene.add_child(b)
	b.burst(direction, origin)

func spawn_splatter(pos: Vector2, normal: Vector2):
	var s: Node = splatter_scene.instantiate()
	get_tree().current_scene.add_child(s)
	s.global_position = pos + normal * 1.0
	s.rotation = normal.angle() + PI/2
	s.rotation += randf_range(-0.3, 0.3)
	s.scale *= randf_range(0.7, 1.3)

	splatters.append(s)
	if splatters.size() > max_splatters:
		var oldest = splatters.pop_front()
		if is_instance_valid(oldest):
			oldest.queue_free()
