extends CharacterBody2D


@export var speed = 50.0
@export var atk = 10.0
@onready var parent = self.get_parent()
@onready var player = self.get_parent().get_child(0)

var index = 0


func _physics_process(delta: float) -> void:
	var path = parent.return_path()
	if path.is_empty() or index >= path.size():
		velocity = Vector2i.ZERO
		move_and_slide()
		return
		
	var target = path[index]
	var direction = (target-global_position).normalized()
	velocity = direction * speed

	move_and_slide()
	
	if global_position.distance_to(target) <= 4.0:
		index += 1

func attack():
	if global_position.distance_to(player.global_position) <= 4.0:
		player.health -= atk
