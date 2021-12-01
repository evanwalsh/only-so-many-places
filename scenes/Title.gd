extends Control

onready var play_button := $Buttons/PlayButton
onready var quit_button = $Buttons/QuitButton

var _play_scene_path := "res://scenes/Explanation.tscn"


func _ready():
	play_button.connect("button_up", self, "_on_play_button_up")
	quit_button.connect("button_up", self, "_on_quit_button_up")


func _on_play_button_up() -> void:
	get_tree().change_scene(_play_scene_path)


func _on_quit_button_up() -> void:
	Events.emit_signal("quit")
