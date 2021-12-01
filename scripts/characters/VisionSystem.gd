class_name VisionSystem
extends Node2D

# Path to body used for rotation and position checks
export var body_path := NodePath()
# Range in pixels to check for vision
export(int, 9000) var vision_range := 150
# Vision field of view in degrees
export(int, 0, 360) var vision_fov := 135
export var rotation_speed := 8

onready var body := get_node(body_path) as Node2D


func face_point(point: Vector2, delta: float) -> void:
	var direction := body.global_position.direction_to(point)

	body.rotation = lerp_angle(
		body.rotation, direction.angle() + Constants.RADIANS_90, rotation_speed * delta
	)


func sees_point(point: Vector2) -> bool:
	return (
		point_within_vision_range(point)
		and point_within_vision_fov(point)
		and point_within_line_of_sight(point)
	)


func point_within_vision_range(point: Vector2) -> bool:
	return body.global_position.distance_to(point) <= vision_range


func point_within_vision_fov(point: Vector2) -> bool:
	var facing_dir := Vector2.UP.rotated(body.rotation).normalized()
	var dir_to_target := body.global_position.direction_to(point)
	var angle := dir_to_target.angle_to(facing_dir)

	return abs(rad2deg(angle)) <= vision_fov / 2.0


func point_within_line_of_sight(point: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state

	# Cast ray and only check if the environment is colliding
	var result := space_state.intersect_ray(
		body.global_position, point, [self], Mask.for_layers([1])
	)

	# If no collision with environment, we're good!
	return !result
