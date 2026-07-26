class_name BossAnimator
extends Node2D

@export var sprite: AnimatedSprite2D
@export var player: BossWizard

var _queue: Array[StringName] = []
var _paused: bool = false


func set_pause(value: bool) -> void:
	_paused = value

func get_sprite() -> AnimatedSprite2D:
	return sprite

func _ready() -> void:
	var _x: bool = sprite.animation_finished.connect(func() -> void: _queue.pop_front())
	sprite.play("default")

func _process(_delta: float) -> void:
	if player.velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if player.velocity.length() >= 10 and _queue.is_empty() and not _paused:
		sprite.play("walk")
	elif _queue.is_empty():
		if not _paused:
			sprite.play("default")
	else:
		sprite.play(_queue[0])

func queue(anim_name: StringName, forced: bool = false) -> void:
	if not anim_name in sprite.sprite_frames.get_animation_names() or not forced and _paused:
		return
	if not _queue.is_empty():
		if anim_name == _queue.back():
			return
	
	if forced:
		sprite.stop()
		_queue = []
		sprite.play(anim_name)
		return
	
	_queue.append(anim_name)

func _next() -> void:
	if _queue.is_empty():
		return
	
	_queue.pop_front()
