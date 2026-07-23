class_name Sentry
extends Ability

func _init(player: Node2D) -> void:
	super._init(player)
	_ability_data = preload("res://abilities/sentry/sentry_data.tres")

func activate_ability() -> void:
	var body: SentryBody = preload("res://abilities/sentry/sentry_body.tscn").instantiate()
	_player.get_tree().current_scene.add_child(body)
