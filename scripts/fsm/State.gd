class_name State
extends Node

# warning-ignore:unused_signal
signal finished(next_state_name)


# Initialize the state. E.g. change the animation
func enter() -> void:
	return


# Clean up the state. Reinitialize values like a timer
func exit() -> void:
	return


func handle_input(_event: InputEvent) -> void:
	return


func update(_delta: float) -> void:
	return


func on_animation_finished(_anim_name: String) -> void:
	return
