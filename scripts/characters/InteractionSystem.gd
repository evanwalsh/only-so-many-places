class_name InteractionSystem
extends Node

# Path to area used for interaction range
export var area_path: NodePath

var current_interactive: Interactive

onready var area := get_node(area_path) as Area2D


func _ready() -> void:
	area.connect("area_entered", self, "_on_area_entered")
	area.connect("area_exited", self, "_on_area_exited")


func interact() -> void:
	var overlapping := area.get_overlapping_areas()
	if overlapping.empty():
		return

	var first_area := overlapping[0] as Area2D

	var interactives = get_tree().get_nodes_in_group(
		Interactive.get_group_name(first_area.get_instance_id())
	)

	if interactives.empty():
		return

	current_interactive = interactives[0] as Interactive
	current_interactive.interact(owner)
	Events.emit_signal("player_interacted" if owner == Game.player else "mom_interacted")


func can_interact_with(object: Interactive) -> bool:
	return area.overlaps_area(object.area)


func _on_area_entered(ext_area: Area2D) -> void:
	if owner != Game.player:
		return

	var interactive := ext_area.get_parent() as Interactive
	if !interactive:
		return

	interactive.set_interactable(true)


func _on_area_exited(ext_area: Area2D) -> void:
	if owner != Game.player:
		return

	var interactive := ext_area.get_parent() as Interactive
	if !interactive:
		return

	interactive.set_interactable(false)
