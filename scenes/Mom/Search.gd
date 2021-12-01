extends State

onready var mom := owner as Mom


func enter() -> void:
	mom.stop_moving()

	if mom.player_sighted:
		emit_signal("finished", "chase")
		return


func update(delta: float) -> void:
	if mom.player_sighted:
		emit_signal("finished", "chase")

	var scent = get_scent()

	if is_instance_valid(scent):
		mom.move_toward_point(scent.global_position)
		mom.vision_system.face_point(scent.global_position, delta)
	else:
		emit_signal("finished", "look_around")


func get_scent() -> Object:
	for scent in mom.player.scents:
		if mom.vision_system.sees_point(scent.global_position):
			return scent

	return null
