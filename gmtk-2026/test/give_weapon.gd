extends Button

@onready var weapon: ConjureWeapon = ConjureWeapon.new(player, preload("res://abilities/conjure_weapon/weapons_data/sword.tres"))
@export var player: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	player.set_ability(0, weapon)
