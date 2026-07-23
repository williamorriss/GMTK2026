class_name SlowTime
extends Ability

var duration: float = 3
var transition_time: float = 0.3
var slowdown_factor: float = 0.5

# [TODO] add post processing to show time is slowed

func _init(player: Node2D) -> void:
	super._init(player)
	_ability_data = preload("res://abilities/slow_time/slow_time_data.tres")

func activate_ability() -> void:
	if Engine.time_scale != 1:
		return
	
	var tween: Tween = _player.get_tree().current_scene.create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_property(Engine, "time_scale", slowdown_factor, transition_time)
	await tween.finished
	
	await _player.get_tree().create_timer(duration).timeout
	
	var tween2: Tween = _player.get_tree().current_scene.create_tween()
	tween2.set_ignore_time_scale(true)
	tween2.tween_property(Engine, "time_scale", 1.0, transition_time)
	await tween.finished
