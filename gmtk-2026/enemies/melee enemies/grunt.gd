extends CharacterBody2D


@export var speed = 50.0
@export var atk = 10.0
@export var player: Node2D



func _ready():
	add_to_group("enemies")
	
func _physics_process(delta: float) -> void:
		
	var target = player.global_position
	var direction = (target-global_position).normalized()
	velocity = direction * speed

	move_and_slide()
	

func attack():
	if global_position.distance_to(player.global_position) <= 4.0:
		player.health -= atk
		var temp_velocity = velocity
		velocity = velocity * -0.1
		move_and_slide()
		velocity = temp_velocity
