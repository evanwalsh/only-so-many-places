class_name DescriptionLabel
extends Node2D

export var text := "Description goes here!" setget set_text
export var timeout := 5.0

var parent_id: int
var timer: Timer

onready var label := $Panel/Label as Label


func _ready() -> void:
	label.text = text
	_add_timer()


func set_text(value: String) -> void:
	text = value

	if label:
		label.text = value


func _add_timer() -> Timer:
	timer = Timer.new()
	timer.pause_mode = Node.PAUSE_MODE_STOP
	timer.wait_time = timeout
	timer.autostart = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)

	return timer


func _on_timeout() -> void:
	DescriptionManager.hide_by_id(parent_id)
