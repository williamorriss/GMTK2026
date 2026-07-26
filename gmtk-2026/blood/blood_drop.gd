class_name BloodDrop
extends Node2D

@export var orbulation_health_factor: float = 0.3
@onready var blood_drop: PackedScene = preload("res://blood/blood_orb.tscn")

func orbulate(hp: float) -> void:
	return
	print("orbulation commencing")
	var root: Node = get_tree().current_scene
	var total: float = hp
	var orbulation_factor: int = randi_range(1,5)
	
	for i: int in range(orbulation_factor):
		var drop: BloodOrb = blood_drop.instantiate()
		drop.hp = (total / orbulation_factor) * orbulation_health_factor
		drop.global_position = global_position
		root.add_child.call_deferred(drop)
