class_name BossAnimator
extends Node2D

@export var sprite: AnimatedSprite2D
@export var injured: AnimatedSprite2D
@export var player: BossWizard

var _current: AnimatedSprite2D

var _queue: Array[StringName] = []
var _paused: bool = false


func set_pause(value: bool) -> void:
	_paused = value

func get_sprite() -> AnimatedSprite2D:
	return _current

func _ready() -> void:
	_current = sprite
	var _x: bool = sprite.animation_finished.connect(func() -> void: _queue.pop_front())
	var _y: bool = injured.animation_finished.connect(func() -> void: _queue.pop_front())
	_current.play("default")

func _process(_delta: float) -> void:
	if player.velocity.x < 0:
		_current.flip_h = true
	else:
		_current.flip_h = false
	
	if player.velocity.length() >= 10 and _queue.is_empty() and not _paused:
		_current.play("walk")
	elif _queue.is_empty():
		if not _paused:
			_current.play("default")
	else:
		_current.play(_queue[0])
	
	if player._current_phase is Phase2:
		_current = injured
		sprite.visible = false
		injured.visible = true
	else:
		_current = sprite
		sprite.visible = true
		injured.visible = false

func queue(anim_name: StringName, forced: bool = false) -> void:
	if not anim_name in _current.sprite_frames.get_animation_names():
		return
	if not _queue.is_empty():
		if anim_name == _queue.back():
			return
	
	if forced:
		_queue = []
		_current.stop()
		_current.play(anim_name)
		return
	
	_queue.append(anim_name)

func _next() -> void:
	if _queue.is_empty():
		return
	
	_queue.pop_front()
