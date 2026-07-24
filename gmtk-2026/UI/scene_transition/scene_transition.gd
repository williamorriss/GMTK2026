extends CanvasLayer

@export var rect: ColorRect
@export var transition_length: float

func _ready() -> void:
	rect.visible = false
	rect.modulate.a = 0.0

func change_scene(path: String) -> void:
	await _fade_in()
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await  _fade_out()

func _fade_in() -> void:
	rect.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, transition_length / 2)
	await tween.finished

func _fade_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, transition_length / 2)
	await tween.finished
	rect.visible = false
