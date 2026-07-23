extends CharacterBody2D


@export var speed: float = 20.0
@export var atk: float = 5.0
@export var range: float = 10.0
@export var player: Node2D

func _ready():
	add_to_group("enemies")
	
