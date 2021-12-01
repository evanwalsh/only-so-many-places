# class_name DescriptionManager
extends Node

const DescriptionLabelScene = preload("res://scenes/DescriptionLabel.tscn")

var labels := {}


func show(node: Node2D, text_id: String) -> void:
	# TODO: Use tweens to make this visually nicer for the player
	var node_id := node.get_instance_id()
	if labels.has(node_id):
		return

	var label := DescriptionLabelScene.instance()
	label.text = tr(text_id)
	label.parent_id = node_id
	label.rotation = -node.rotation

	node.add_child(label)
	labels[node_id] = label


func hide(node: Node2D) -> void:
	var node_id := node.get_instance_id()
	hide_by_id(node_id)


func hide_by_id(node_id: int) -> void:
	if !labels.has(node_id):
		return

	labels[node_id].queue_free()
	labels.erase(node_id)
