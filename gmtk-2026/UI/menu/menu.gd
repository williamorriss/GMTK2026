class_name Menu
extends CanvasLayer

@export_group("Scene")
@export_file("*.tscn") var next_scene: String

@export_group("Controls")
@export var menuControl: Control
@export var optionsControl: Control
@export var creditsControl: Control

func _ready() -> void:
	menuControl.visible = true
	optionsControl.visible = false
	creditsControl.visible = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(next_scene)

func _on_options_button_pressed() -> void:
	menuControl.visible = false
	optionsControl.visible = true
	creditsControl.visible = false

func _on_credits_pressed() -> void:
	menuControl.visible = false
	optionsControl.visible = false
	creditsControl.visible = true

func _on_back_button_pressed() -> void:
	menuControl.visible = true
	optionsControl.visible = false
	creditsControl.visible = false
