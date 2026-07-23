extends Control

func _on_master_slider_value_changed(value: float) -> void:
	var index: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(index, value)

func _on_sfx_slider_value_changed(value: float) -> void:
	var index: int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(index, value)

func _on_music_slider_value_changed(value: float) -> void:
	var index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(index, value)
