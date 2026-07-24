extends Area2D

var enemies = []
var room_cleared: bool = false
var doors_closed: bool = false
var enemies_spawned: bool = false
var grunt_scene = preload("res://enemies/melee enemies/grunt.tscn")
var ranged_grunt_scene = preload("res://enemies/ranged enemies/ranged_grunt.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print(enemies.size())

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	open_doors()

func _on_body_entered(body):
	if enemies.is_empty() and !room_cleared and !enemies_spawned and body.is_in_group("players"):
		var doors = find_doors(self,%tile_map)
		for door in doors:
			%tile_map.set_cell(door,0,Vector2i(4,3)) #change this to an open and close door scenario
	
	doors_closed = true
	
	if !enemies_spawned and !room_cleared:
		enemies_spawned = true
		await get_tree().create_timer(0.5).timeout
		spawn_enemies()

		print(enemies.size())

func find_doors(area : Area2D, tilemap : TileMapLayer):
	var door_tiles : Array[Vector2i]= []
	var shape_node = area.get_node("CollisionShape2D") as CollisionShape2D
	var shape = shape_node.shape
	
	var search_area = Rect2(shape_node.global_position + shape.get_rect().position,shape.get_rect().size)
	var top_left = tilemap.local_to_map(tilemap.to_local(search_area.position))
	var bottom_right = tilemap.local_to_map(tilemap.to_local(search_area.position + shape.size))
	
	for x in range(top_left.x, bottom_right.x + 1):
		for y in range(top_left.y, bottom_right.y + 1):
			var cell = Vector2i(x,y)
			var data = tilemap.get_cell_tile_data(cell)
			if data and data.get_custom_data("Door"):
				door_tiles.append(cell)
				
	return door_tiles
	
func spawn_enemies():
	var spawn_positions = $spawn_points.get_children()
	for i in range(3):
		var grunt = grunt_scene.instantiate()

		
		grunt.died.connect(_on_enemy_died.bind(grunt))
		enemies.append(grunt)
		call_deferred("_add_enemy",grunt,spawn_positions[i].global_position)

		
	var ranged_grunt = ranged_grunt_scene.instantiate()

	ranged_grunt.died.connect(_on_enemy_died.bind(ranged_grunt))
	enemies.append(ranged_grunt)
	call_deferred("_add_enemy",ranged_grunt,spawn_positions[3].global_position)
	
func open_doors():
	if enemies.is_empty() and doors_closed and enemies_spawned:
		doors_closed = false
		room_cleared = true
		var doors = find_doors(self,%tile_map)
		for door in doors:
			%tile_map.set_cell(door,0,Vector2i(11,6)) #also change this
		

func _on_enemy_died(enemy):
	enemies.erase(enemy)

func _add_enemy(enemy, spawn_pos):
	add_child(enemy)
	enemy.global_position = spawn_pos

	
	
	
	
