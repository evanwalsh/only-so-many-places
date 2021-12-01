class_name PlayerCamera
extends Camera2D

export(float, 0.4) var scale_lean := 0.4
export(float, 20.0) var smooth_lean := 5.0


func _process(delta) -> void:
	_offset_toward_mouse(delta)


func _offset_toward_mouse(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()

	var direction_to_mouse := global_position.direction_to(mouse_pos).normalized()
	var distance_to_mouse := mouse_pos.distance_to(global_position)
	var lean := direction_to_mouse * distance_to_mouse * scale_lean

	offset = lerp(offset, lean, delta * smooth_lean)
