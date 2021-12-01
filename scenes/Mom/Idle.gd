extends State

onready var mom := owner as Mom


func enter() -> void:
	return


func exit() -> void:
	return


func handle_input(_event: InputEvent) -> void:
	return


func update(_delta: float) -> void:
	mom.stop_moving()
	emit_signal("finished", "work")
