extends Control

@export var master: Slider
@export var sfx: Slider
@export var music: Slider

func _ready() -> void:
	var index: int = AudioServer.get_bus_index("Master")
	master.value = AudioServer.get_bus_volume_db(index)
	
	index = AudioServer.get_bus_index("SFX")
	sfx.value = AudioServer.get_bus_volume_db(index)
	
	index = AudioServer.get_bus_index("Music")
	music.value = AudioServer.get_bus_volume_db(index)

func _on_master_slider_value_changed(value: float) -> void:
	var index: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(index, value)

func _on_sfx_slider_value_changed(value: float) -> void:
	var index: int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(index, value)

func _on_music_slider_value_changed(value: float) -> void:
	var index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(index, value)
