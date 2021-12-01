# class_name Game
extends Node

const EndGameUI = preload("res://scenes/EndGameUI.tscn")

var mom: Mom
var player: Player setget _set_player
var _retry_scene_path := "res://scenes/Apartment.tscn"


func _ready():
	Events.connect("start_game", self, "_on_start_game")
	Events.connect("end_game", self, "_on_end_game")
	Events.connect("quit", self, "_on_quit")
	Events.connect("retry", self, "_on_retry")


func _set_player(value: Player) -> void:
	player = value

	if is_instance_valid(mom):
		(mom as Node2D).player = value


func _on_start_game() -> void:
	var interactives = get_tree().get_nodes_in_group(Interactive.GROUP)
	interactives.shuffle()
	var cable_haver = interactives[0]

	if cable_haver is Console:
		cable_haver = interactives[1]

	cable_haver.has_cable = true
	prints("Gave cable to", cable_haver)


func _on_end_game(won: bool):
	var tree := get_tree()
	tree.call_group("in_game_ui", "set_visible", false)

	var ui = EndGameUI.instance()
	ui.won = won

	tree.current_scene.add_child(ui)
	tree.paused = true


func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			_on_quit()


func _on_quit() -> void:
	get_tree().quit()


func _on_retry() -> void:
	var tree := get_tree()
	tree.change_scene(_retry_scene_path)
	tree.paused = false
