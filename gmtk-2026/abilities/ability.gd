class_name Ability
extends RefCounted

var _player: Node2D 
var _ability_data: AbilityData

var _is_evil: bool = false
var _target: Vector2

func _init(player: Node2D, is_evil: bool = false) -> void:
	_player = player
	_is_evil = is_evil

func set_target(value: Vector2) -> void:
	_target = value

func set_player(player: Node2D) -> void:
	_player = player

func get_cost() -> float:
	if not _ability_data:
		push_warning("Data not set")
		return 0
	
	return _ability_data.cost

func get_ability_data() -> AbilityData:
	return _ability_data

func activate_ability() -> void:
	pass

func process(_delta: float) -> void:
	pass
