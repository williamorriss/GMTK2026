class_name Ability
extends RefCounted

var _player: Node2D 
var _ability_data: AbilityData

func _init(player: Node2D) -> void:
	push_error("func `set_player` not set")

func get_cost() -> float:
	if not _ability_data:
		push_warning("Data not set")
		return 0
	
	return _ability_data.cost

func activate_ability() -> void:
	push_error("func `activate_ability` not set")

func process(_delta: float) -> void:
	push_error("func `procss` not set")
