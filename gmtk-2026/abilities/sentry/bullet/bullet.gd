class_name Bullet
extends Area2D

static func _create_bullet() -> Bullet:
	var instance: Bullet = preload("res://abilities/sentry/bullet/bullet.tscn").instantiate()
	return instance
