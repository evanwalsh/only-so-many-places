extends Node2D


func _ready():
	Events.emit_signal("start_game")
