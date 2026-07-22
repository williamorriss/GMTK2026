class_name ChromaticOrb
extends Ability

func _init(player: Node2D) -> void:
	super._init(player)
	_ability_data = preload("res://abilities/chromatic_orb/orb_data.tres")

func activate_ability() -> void:
	var instance: ChromaticBody = ChromaticBody.create_orb(_player)
	_player.get_tree().current_scene.add_child(instance)
