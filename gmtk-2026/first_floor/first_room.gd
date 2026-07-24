extends Area2D

var enemies = []
var room_cleared: bool = false
var doors_closed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if enemies.is_empty() and !room_cleared:
		var doors = find_doors(self,%tile_map)
		for door in doors:
			%tile_map.set_cell(door,-1,Vector2i(4,3))
	
	doors_closed = true

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
	
	
	
