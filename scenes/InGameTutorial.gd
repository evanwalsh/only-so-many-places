class_name InGameTutorial
extends Control

# TODO: Abstract this into a sub-scene that can be provided an input name
onready var forward_binding: Label = $VBoxContainer/MoveForward/Binding
onready var backward_binding: Label = $VBoxContainer/MoveBackward/Binding
onready var left_binding: Label = $VBoxContainer/MoveLeft/Binding
onready var right_binding: Label = $VBoxContainer/MoveRight/Binding
onready var interact_binding: Label = $VBoxContainer/Interact/Binding
onready var pause_binding: Label = $VBoxContainer/Pause/Binding


func _ready():
	_set_binding_label("move_forward", forward_binding)
	_set_binding_label("move_backward", backward_binding)
	_set_binding_label("move_left", left_binding)
	_set_binding_label("move_right", right_binding)
	_set_binding_label("interact", interact_binding)
	_set_binding_label("pause", pause_binding)


func _set_binding_label(action: String, label: Label) -> void:
	var actions = InputMap.get_action_list(action)
	label.text = actions[0].as_text()


func set_visible(value: bool) -> void:
	visible = value
