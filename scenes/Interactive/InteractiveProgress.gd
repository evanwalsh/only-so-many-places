class_name InteractiveProgress
extends Node2D

var value := 0.0 setget set_value, get_value

onready var progress_bar := $ProgressBar as ProgressBar


func _ready():
	pass


func set_value(new_value: float) -> void:
	progress_bar.value = new_value


func get_value() -> float:
	return progress_bar.value
