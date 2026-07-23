class_name ManaSpikes
extends Ability

func _init(player: Node2D) -> void:
	super._init(player)
	_ability_data = preload("res://abilities/mana_spikes/spikes_data.tres")

func activate_ability() -> void:
	var direction: Vector2 = (_player.get_global_mouse_position() - _player.position).normalized()
	var instance: SpikeTrap = SpikeTrap.create_trap(_player.position, direction)
	_player.get_tree().current_scene.add_child(instance)
