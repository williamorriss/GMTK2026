extends Area2D

@export_file("*.tscn") var next_scene: String
@export_file("*.tscn") var next_level: String

func _ready() -> void:
	var _x: bool = body_entered.connect(_entered)

func _entered(body: Node2D) -> void:
	if body is Player:
		StateHolder.set_next_level(next_level)
		await SceneTransition.change_scene(next_scene)
