extends Area2D

@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	var _x: bool = body_entered.connect(_entered)

func _entered(body: Node2D) -> void:
	if body is Player:
		StateHolder.set_next_level(next_scene)
		await SceneTransition.change_scene("res://UI/next_level/next_scene.tscn")
