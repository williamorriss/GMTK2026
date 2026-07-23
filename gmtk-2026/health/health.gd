class_name Health
extends Node
signal damage_taken(value: float, new_hp: float)
signal dead

var _hp: float = 0.0 

func damage(points: float) -> void:
	if points > 0:
		push_error("To heal damage use heal/ set_hp >:(")
		
	_hp -= points
	if _hp < 0:
		dead.emit()
	
func get_hp() -> float:
	return _hp

func heal(points: float) -> void:
	if points < 0:
		push_error("To deal damage use damage/ set_hp >:(")
		
	_hp += points

func set_hp(hp: float) -> void:
	_hp = hp
	if _hp < 0:
		dead.emit()

func _init(hp: float) -> void:
	_hp = hp
	if _hp < 0:
		dead.emit()
