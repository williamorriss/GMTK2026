class_name BossAnimator
extends Node2D

@export var sprite: AnimatedSprite2D
@export var player: BossWizard

var _previous: StringName = ""
var _queue: Array[StringName] = []

func _ready() -> void:
	var _x: bool = sprite.animation_finished.connect(func() -> void: _queue.pop_front())
	sprite.play("default")

func _process(_delta: float) -> void:
	print(_queue)
	
	if player.velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if player.velocity.length() >= 10 and _queue.is_empty():
		sprite.play("walk")
	elif _queue.is_empty():
		sprite.play("default")
	else:
		sprite.play(_queue[0])
	

func queue(anim_name: StringName) -> void:
	if _previous == anim_name:
		print("hi")
		return
	if not _queue.is_empty():
		if anim_name == _queue.back():
			return
	
	_previous = anim_name
	_queue.append(anim_name)

func _next() -> void:
	if _queue.is_empty():
		return
	
	_queue.pop_front()
