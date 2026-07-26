class_name Door
extends StaticBody2D

@export var door1: AnimatedSprite2D
@export var door2: AnimatedSprite2D
@export var shape: CollisionShape2D

func _ready() -> void:
	shape.disabled = true
	_play("open")

func open() -> void:
	shape.disabled = true
	_play("open")

func close() -> void:
	shape.disabled = false
	_play("close")

func _play(value: StringName) -> void:
	door1.play(value)
	door2.play(value)
