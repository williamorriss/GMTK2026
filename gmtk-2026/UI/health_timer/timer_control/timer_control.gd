class_name TimerControl
extends Node2D

enum States{
	START,
	STOP
}

@export var state: States = States.START

func _ready() -> void:
	match state:
		States.START:
			await HealthTimer.start_timer()
		States.STOP:
			HealthTimer.stop_timer()
