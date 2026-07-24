extends Node

@export_group("Buttons")
@export var bind_button: Control
@export var audio_button: Control

@export_group("Controls")
@export var audio_control: Control
@export var bind_control: Control

@export_group("Audio")
@export var select_audio: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_audio_visibility(true)
	_set_binding_visibility(false)

func _set_audio_visibility(value: bool) -> void:
	audio_button.visible = not value
	audio_control.visible = value

func _set_binding_visibility(value: bool) -> void:
	bind_button.visible = not value
	bind_control.visible = value

func _on_bind_button_pressed() -> void:
	AudioManager.play_sfx(select_audio)
	_set_audio_visibility(false)
	_set_binding_visibility(true)

func _on_audio_button_pressed() -> void:
	AudioManager.play_sfx(select_audio)
	_set_audio_visibility(true)
	_set_binding_visibility(false)
