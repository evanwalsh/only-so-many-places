class_name Console
extends Interactive


func _on_complete_interact(actor: KinematicBody2D, is_player: bool) -> void:
	if !is_player:
		return

	var player: Player = actor

	if player.has_cable:
		Events.emit_signal("end_game", true)
	else:
		audio_player.play()
		DescriptionManager.show(self, "OBJECT_CONSOLE_NO_CABLE")
