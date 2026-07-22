extends CharacterBody2D


var speed = 20.0
@onready var parent = self.get_parent()
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
