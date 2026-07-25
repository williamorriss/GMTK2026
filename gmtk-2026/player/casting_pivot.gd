extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = (get_global_mouse_position() - global_position).normalized()
	position = dir * 133.0
	rotation = dir.angle()
