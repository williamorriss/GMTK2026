extends CharacterBody2D

@export var agent: NavigationAgent2D

@export var speed: float = 50.0
@export var atk: float = 10.0
@export var player: Node2D

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	agent.target_position = player.position
	
	var next_point: Vector2 = agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_point)
	
	velocity = direction * speed
	move_and_slide()
	

func attack() -> void:
	pass
	#will do later
