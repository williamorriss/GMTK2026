class_name MagicMissile
extends Ability

var missile_amount: int = 3
var _can_activate: bool = true

func _init(player: Node2D) -> void:
	super._init(player)
	_ability_data = preload("res://abilities/magic_missile/magic_missile_data.tres")

func activate_ability() -> void:
	if not _can_activate:
		return
	
	_can_activate = false
	var looksie: Array[Missile] = []
	
	for amt: int in range(missile_amount):
		var instance: Missile = Missile.create_missile(_player)
		_player.get_tree().current_scene.add_child(instance)
		looksie.append(instance)
	
	if looksie.size() <= 0:
		push_warning("No missiles fired")
		return
	
	await looksie[0].on_finish_rotating
	_can_activate = true
