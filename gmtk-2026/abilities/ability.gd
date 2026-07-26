class_name Ability
extends RefCounted

var _player: Node2D 
var _ability_data: AbilityData

var _is_evil: bool = false
var _target: Vector2

var _can_activate: bool = true
var _is_waiting: bool = false

func _init(player: Node2D) -> void:
	_player = player

func set_evil(value: bool) -> void:
	_is_evil = value
func set_target(value: Vector2) -> void:
	_target = value

func set_player(player: Node2D) -> void:
	_player = player as Player

func get_cost() -> float:
	if not _ability_data:
		push_warning("Data not set")
		return 0
	
	return _ability_data.cost

func get_ability_data() -> AbilityData:
	return _ability_data

func set_can_activate(value: bool) -> void:
	_can_activate = value

func activate_ability() -> void:
	if _is_evil:
		_can_activate = true
		return
	
	if not _can_activate and not _is_waiting:
		_is_waiting = true
		var _x: bool = _player.get_tree().create_timer(_ability_data.cooldown).timeout.connect(func() -> void:
			_is_waiting = false
			_can_activate = true
		)

func process(_delta: float) -> void:
	pass
