extends Node2D

var _current_abilities: Array[Ability] = [null, null, null, null]

# [NOTE] this is a test for now initial abilities will change
func _init() -> void:
	set_default_abilities()

func set_default_abilities() -> void:
	_current_abilities[0] = ConjureWeapon.new(null, preload("res://abilities/conjure_weapon/weapons_data/sword.tres"))
	_current_abilities[1] = ChromaticOrb.new(null)
	_current_abilities[2] = Thorns.new(null)
	_current_abilities[3] = null

func set_current_ability(pos: int, ability: Ability) -> void:
	if pos < 0 or pos > 4:
		push_error("Index out of range")
		return
	
	_current_abilities[pos] = ability

func get_current_ability(pos: int, player: Node2D = null) -> Ability:
	if pos < 0 or pos > 4:
		push_error("Index out of range")
		return
	
	if _current_abilities[pos]:
		_current_abilities[pos].set_player(player)
	
	return _current_abilities[pos]

func get_current_abilities() -> Array[Ability]:
	return _current_abilities
