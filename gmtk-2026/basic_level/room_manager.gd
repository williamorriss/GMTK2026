extends Area2D

const gruntScene = preload("res://enemies/melee enemies/grunt.tscn")
var current_enemies = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	spawn_enemy()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_enemies.is_empty():
		open_doors()
		
func spawn_enemy():
	for i in range(3):
		var grunt = gruntScene.instantiate()
		grunt.position = self.global_position + Vector2(10,10*i)
		self.add_child(grunt)
		current_enemies.append(grunt)
		
func _on_body_entered(body):
	print("body entered:" + body.name)
	%tile_map.set_cell(Vector2i(-1,-4),0,Vector2i(4,3))
	%tile_map.set_cell(Vector2i(0,-4),0,Vector2i(4,3))
	%tile_map.set_cell(Vector2i(-1,-5),0,Vector2i(2,2))
	%tile_map.set_cell(Vector2i(0,-5),0,Vector2i(2,2))
	%tile_map.set_cell(Vector2i(6,0),0,Vector2i(7,5))
	%tile_map.set_cell(Vector2i(6,1),0,Vector2i(7,5))
	
func open_doors():

	%tile_map.set_cell(Vector2i(-1,-4),-1)
	%tile_map.set_cell(Vector2i(0,-4),-1)
	%tile_map.set_cell(Vector2i(-1,-5),-1)
	%tile_map.set_cell(Vector2i(0,-5),-1)
	%tile_map.set_cell(Vector2i(6,0),-1)
	%tile_map.set_cell(Vector2i(6,1),-1)
	
