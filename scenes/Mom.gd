class_name Mom
extends KinematicBody2D

const MAX_ANNOYANCE = 100
const StatusStreamAlert = preload("res://audio/Mom/alert.wav")
const StatusStreamLostPlayer = preload("res://audio/Mom/lost_player.wav")

export var annoyance_decay_per_tick := 1
export var navigation_path := NodePath()
export var debug_vision := false
export var rooms_areas_path := NodePath()
export(Array, NodePath) var raycast_paths = []

var current_room_id: int = RoomArea.ID.UNKNOWN
var player_sighted := false setget set_player_sighted
var annoyance := 25 setget _set_annoyance
var annoyance_factor := 1.0
var raycasts = []
var avoid_force := 0.85
var should_work := false
var patrol = []
var patrol_index := 0
var player: Player

onready var character_mover: CharacterMover = $CharacterMover
onready var vision_system: VisionSystem = $VisionSystem
onready var interaction_system: InteractionSystem = $InteractionSystem
onready var sprite: Sprite = $Sprite
onready var state_machine: StateMachine = $StateMachine
onready var step_player: AudioStreamPlayer2D = $StepPlayer
onready var status_player: AudioStreamPlayer2D = $StatusPlayer
onready var step_timer: Timer = $StepTimer
onready var annoyance_decay_timer: Timer = $AnnoyanceDecayTimer
onready var annoyance_growth_timer: Timer = $AnnoyanceGrowthTimer
onready var navigation := get_node(navigation_path) as Navigation2D
onready var room_areas := get_node(rooms_areas_path) as RoomAreas
onready var vision_fov_deviation := deg2rad(vision_system.vision_fov / 2)  # warning-ignore:integer_division
onready var vision_range_edge := Vector2(0, -vision_system.vision_range)
onready var player_detector: Area2D = $PlayerDetector


func _ready() -> void:
	Game.mom = self
	player = Game.player

	step_timer.connect("timeout", self, "_play_step")
	annoyance_decay_timer.connect("timeout", self, "_decay_annoyance")
	annoyance_growth_timer.connect("timeout", self, "_grow_annoyance")
	player_detector.connect("body_entered", self, "_on_player_detector_body_entered")

	for path in raycast_paths:
		raycasts.append(get_node(path))

	_set_patrol()


func _draw() -> void:
	if debug_vision:
		var cone_color := Color.red if player_sighted else Color.white

		# Draw vision cone
		draw_line(
			Vector2.ZERO,
			vision_range_edge.rotated(vision_fov_deviation + sprite.rotation),
			cone_color
		)
		draw_line(
			Vector2.ZERO,
			vision_range_edge.rotated(-vision_fov_deviation + sprite.rotation),
			cone_color
		)

		var angle := Vector2.UP.rotated(sprite.rotation).angle()
		draw_arc(
			Vector2.ZERO,
			vision_system.vision_range,
			angle - vision_fov_deviation,
			angle + vision_fov_deviation,
			8,
			cone_color
		)


func _physics_process(_delta) -> void:
	if debug_vision:
		update()

	set_player_sighted(sees_player())

	if character_mover.direction != Vector2.ZERO and step_timer.is_stopped():
		step_timer.start()
	elif character_mover.direction == Vector2.ZERO:
		step_timer.stop()


func stop_moving() -> void:
	character_mover.direction = Vector2.ZERO


func move_toward_point(point: Vector2) -> void:
	var path := navigation.get_simple_path(global_position, point, false)

	var direction := path[1] - global_transform.origin
	character_mover.direction = direction.normalized()
	character_mover.direction += _get_avoidance_direction()


func move_toward_player() -> void:
	move_toward_point(player.global_position)


func sees_player() -> bool:
	return vision_system.sees_point(player.global_position)


func step_patrol() -> void:
	patrol_index = wrapi(patrol_index + 1, 0, patrol.size())
	pass


func get_patrol_destination() -> Interactive:
	return patrol[patrol_index] as Interactive


func set_player_sighted(value: bool) -> void:
	if value:
		annoyance += player.get_annoyance_on_sight()

	if value == player_sighted:
		return

	if value and annoyance_growth_timer.is_stopped():
		_set_annoyance(annoyance + _get_annoyance_per_tick())
		annoyance_growth_timer.start()
	elif !value:
		annoyance_growth_timer.stop()

	player_sighted = value


func _play_step() -> void:
	step_player.pitch_scale = rand_range(0.9, 1.1)
	step_player.play()


func _set_annoyance(value: int) -> void:
	annoyance = int(clamp(value, 0, MAX_ANNOYANCE))
	Events.emit_signal("mom_annoyance_changed", annoyance)


func _decay_annoyance() -> void:
	if !annoyance_growth_timer.is_stopped():
		return

	_set_annoyance(annoyance - annoyance_decay_per_tick)


func _grow_annoyance() -> void:
	prints("Growing annoyance", _get_annoyance_per_tick())
	_set_annoyance(annoyance + _get_annoyance_per_tick())


func _get_annoyance_per_tick() -> int:
	return room_areas.areas[player.current_room_id].annoyance_per_tick


func _get_avoidance_direction():
	for raycast in raycasts:
		if raycast.is_colliding():
			var obstacle: Node2D = raycast.get_collider()
			return (
				(global_position + character_mover.direction - obstacle.global_position).normalized()
				* avoid_force
			)

	return Vector2.ZERO


func _on_player_detector_body_entered(body: KinematicBody2D) -> void:
	if body != player:
		return

	if annoyance >= MAX_ANNOYANCE or player.has_cable:
		Events.emit_signal("end_game", false)


func play_status_stream(stream: AudioStream) -> void:
	status_player.pitch_scale = rand_range(0.8, 1.2)
	status_player.stream = stream
	status_player.play()


func _set_patrol() -> void:
	var interactives = get_tree().get_nodes_in_group(Interactive.GROUP)
	interactives.shuffle()
	var size = interactives.size()

	patrol = interactives.slice(0, rand_range(size / 2, size))


func should_chase_player() -> bool:
	return annoyance >= 50 or player.has_cable
