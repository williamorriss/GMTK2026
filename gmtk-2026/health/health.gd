class_name Health
extends Node2D

signal on_damage_taken(dealer: Owner, taker: Owner, value: float, new_hp: float)
signal on_dead(dealer: Owner, taker: Owner, direction: Vector2)

@export var max_health: float = 100

var _hp: float = 0.0 
var _is_immune: bool = false
var _owner: Owner

enum Owner {
	Player,
	Friendly,
	Enemy,
	Neutral
}
	
func _ready() -> void:
	_hp = max_health
	if _hp <= 0:
		on_dead.emit()

	var parent: Node = get_parent()
	if parent.is_in_group("player"):
		_owner = Owner.Player
	elif parent.is_in_group("players"):
		_owner = Owner.Friendly
	elif parent.is_in_group("enemies"):
		_owner = Owner.Enemy
	else:
		_owner = Owner.Neutral
	

# what is this -_-
static func get_health(target: Node) -> Health:
	var healths: Array = []
	for child: Node in target.get_children():
		if child is Health:
			healths.append(child)
	
	if healths.size() > 1:
		push_warning("Multiple health in a node when searching")
	
	if healths.size() == 1:
		return healths.front()
	
	return null

func set_immunity(value: bool) -> void:
	_is_immune = value

func damage(points: float, direction: Vector2, dealer: Owner, forced: bool = false) -> void:
	if points < 0:
		push_error("To heal damage use heal/ set_hp >:( no negatives")
	if _is_immune and not forced:
		return
	
	_hp -= points
	on_damage_taken.emit(dealer, _owner, points, _hp)
	if _hp <= 0:
		on_dead.emit(dealer, _owner, direction)
	
func get_hp() -> float:
	return _hp

func heal(points: float) -> void:
	if points < 0:
		push_error("To deal damage use damage/ set_hp >:(")
		
	_hp += points

func set_hp(hp: float) -> void:
	_hp = hp
	if _hp <= 0:
		on_dead.emit()
