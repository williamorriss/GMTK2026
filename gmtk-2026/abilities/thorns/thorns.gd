class_name Thorns
extends Ability

var amount: int = 16

func _init(player: Node2D) -> void:
	super._init(player)
	_ability_data = preload("res://abilities/thorns/thorns_data.tres")

func activate_ability() -> void:
	for i: int in range(amount):
		var rot: float = (2 * PI) * (float(i) / float(amount))
		var dir: Vector2 = Vector2(cos(rot), sin(rot))
		var instance: ThornBullet = ThornBullet.create_bullet(_player.position, dir)
		_player.get_tree().current_scene.add_child(instance)
