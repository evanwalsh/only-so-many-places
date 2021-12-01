extends Control

var _ready_scene_path := "res://scenes/Apartment.tscn"

onready var ready_button := $Button as Button

func _ready() -> void:
	ready_button.connect("button_up", self, "_on_ready_button_up")

func _on_ready_button_up() -> void:
	get_tree().change_scene(_ready_scene_path)
