class_name Scent
extends Node2D

const GROUP = "scent"

# How long does the scent hang around?
export var lifetime: float = 1.0

var player
var timer := Timer.new()


func _ready():
	add_to_group(GROUP)

	timer.autostart = true
	timer.wait_time = lifetime
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)


func _enter_tree():
	assert(player != null, "You must set a player!")


func _draw():
	if player.debug_scent:
		draw_circle(Vector2.ZERO, 2, Color.lightgreen)


func _on_timeout() -> void:
	expire()


func expire():
	player.scents.erase(self)
	queue_free()
