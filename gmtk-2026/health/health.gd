class_name Health
extends Node2D

signal on_damage_taken(value: float, new_hp: float)
signal on_dead

@export var max_health: float = 100

var _hp: float = 0.0 

static func get_health(target: Node) -> Health:
	var healths: Array = []
	for child: Node in target.get_children():
		if child is Health:
			healths.append(child)
	
	if healths.size() > 1:
		push_warning("Multiple health in a node when searching")
	
	return healths.front()

func damage(points: float) -> void:
	if points < 0:
		push_error("To heal damage use heal/ set_hp >:( no negatives")
		
	_hp -= points
	if _hp < 0:
		on_dead.emit()
	
func get_hp() -> float:
	return _hp

func heal(points: float) -> void:
	if points < 0:
		push_error("To deal damage use damage/ set_hp >:(")
		
	_hp += points

func set_hp(hp: float) -> void:
	_hp = hp
	if _hp < 0:
		on_dead.emit()

func _ready() -> void:
	_hp = max_health
	if _hp < 0:
		on_dead.emit()
