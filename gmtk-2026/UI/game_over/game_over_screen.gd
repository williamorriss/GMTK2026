extends CanvasLayer

@export_file("*.tscn") var next_scene: String
@export var select_audio: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_retry_pressed() -> void:
	AudioManager.play_sfx(select_audio)
	await SceneTransition.change_scene(next_scene)

func _on_quit_pressed() -> void:
	AudioManager.play_sfx(select_audio)
	await AudioManager.get_sfx_player().finished # Maybe a quitting tune or something
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
