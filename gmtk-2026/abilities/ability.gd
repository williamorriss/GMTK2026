class_name Ability
extends RefCounted

var _cost: int = -1

func get_cost() -> float:
	if _cost == -1:
		push_warning("Cost not set")
	return _cost

func activate_ability() -> void:
	pass

func process(_delta: float) -> void:
	pass
