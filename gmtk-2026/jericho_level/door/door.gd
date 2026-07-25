class_name Door
extends StaticBody2D

@export var sprite: Sprite2D
@export var shape: CollisionShape2D

func _ready() -> void:
	shape.disabled = true
	sprite.visible = false

func open() -> void:
	shape.disabled = true
	sprite.visible = false

func close() -> void:
	shape.disabled = false
	sprite.visible = true
