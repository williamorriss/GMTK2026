class_name ChromaticOrb
extends Ability

func activate_ability() -> void:
	var instance: ChromaticBody = ChromaticBody.create_orb(_player)
	_player.get_tree().current_scene.add_child(instance)
