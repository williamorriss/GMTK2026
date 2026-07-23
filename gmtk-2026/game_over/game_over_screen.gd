extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func show_game_over():
	get_tree().paused = true
	show()



func _on_retry_pressed() -> void:
	print("retry")
	

func _on_quit_pressed() -> void:
	print("quit")
