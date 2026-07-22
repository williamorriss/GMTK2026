class_name Ability
extends RefCounted

var _ability_data: AbilityData

func get_cost() -> float:
	if not _ability_data:
		push_warning("Data not set")
		return 0
	
	return _ability_data.cost

func activate_ability() -> void:
	pass

func process(_delta: float) -> void:
	pass
