extends Control

export(Texture) var pointer_texture := load("res://textures/ui/pointer.png")

onready var retry_button := $VBoxContainer/RetryButton
onready var quit_button := $VBoxContainer/QuitButton


func _ready() -> void:
	retry_button.connect("button_up", self, "_on_retry_button_up")
	quit_button.connect("button_up", self, "_on_quit_button_up")
	Events.connect("paused", self, "_on_paused")


func _enter_tree() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var tree := get_tree()
		tree.paused = !tree.paused
		visible = tree.paused

		Events.emit_signal("paused" if visible else "unpaused")


func _on_retry_button_up() -> void:
	Events.emit_signal("retry")


func _on_quit_button_up() -> void:
	Events.emit_signal("quit")


func _on_paused() -> void:
	Input.set_custom_mouse_cursor(pointer_texture)
