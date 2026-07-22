extends Node2D
# Called when the node enters the scene tree for the first time.

var astar = AStarGrid2D.new()
var current_cell = Vector2i(self.global_position / astar.cell_size)
var target_cell = Vector2i($test_node.global_position / astar.cell_size)
func _ready():

	astar.region = Rect2i(0,0,10,10) #using arbitrary values here
	astar.cell_size = Vector2(64,64)
	astar.diagonal_mode = astar.DIAGONAL_MODE_ALWAYS

	astar.update()
	
func _process(delta: float) -> void:
	var path = astar.get_point_path(current_cell, target_cell)
	


	
	
