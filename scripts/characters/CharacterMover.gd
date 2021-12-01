class_name CharacterMover
extends Node

# Path to KinematicBody2D
export var body_path := NodePath()

# Default walking speed
export var speed := 200

# Speed while running
export var run_speed := 325

# Speed while sneaking
export var sneak_speed := 125

# Is movement disabled?
export var frozen := false

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var is_running := false
var is_sneaking := false

# Kinematic body to move
onready var body := get_node(body_path) as KinematicBody2D


func _physics_process(_delta):
	if frozen:
		return

	var current_direction := direction
	var target := current_direction * get_current_speed()

	velocity = body.move_and_slide(target)


func get_current_speed() -> int:
	if is_running:
		return run_speed
	elif is_sneaking:
		return sneak_speed
	else:
		return speed


func run():
	is_running = true
	is_sneaking = false


func walk():
	is_running = false
	is_sneaking = false


func sneak():
	is_sneaking = true
	is_running = false


func freeze():
	frozen = true


func unfreeze():
	frozen = false
