class_name Goal
extends Interactive


func _on_complete_interact(actor: KinematicBody2D, is_player: bool) -> void:
	if is_player:
		DescriptionManager.show(self, "OBJECT_GOAL_DESCRIPTION")
		actor.has_cable = true
