extends State

onready var mom := owner as Mom


func enter() -> void:
	mom.play_status_stream(mom.StatusStreamAlert)


func exit() -> void:
	return


func handle_input(_event: InputEvent) -> void:
	return


func update(delta: float) -> void:
	if mom.player_sighted:
		mom.move_toward_player()
		mom.vision_system.face_point(mom.player.global_position, delta)
	else:
		emit_signal("finished", "search")
