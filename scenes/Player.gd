class_name Player
extends KinematicBody2D

const GROUP = "player"

export var speed := 200.0
export var scent_scene: PackedScene
export var debug_scent := false
export(StreamTexture) var pointer_texture := preload("res://textures/ui/pointer.png")

var dead := false
var scents := []
var current_room_id: int = RoomArea.ID.MY_ROOM setget set_current_room_id
var has_cable := false setget set_has_cable

onready var character_mover: CharacterMover = $CharacterMover
onready var interaction_system: InteractionSystem = $InteractionSystem
onready var sprite: Sprite = $Sprite
onready var scent_timer: Timer = $ScentTimer
onready var step_timer: Timer = $StepTimer
onready var audio_player: AudioStreamPlayer2D = $AudioPlayer


func _ready() -> void:
	Game.player = self

	add_to_group(GROUP)
	scent_timer.connect("timeout", self, "_add_scent")
	step_timer.connect("timeout", self, "_play_step")
	Events.connect("unpaused", self, "_on_unpaused")


func _enter_tree() -> void:
	_setup_mouse()


func _process(_delta) -> void:
	if dead:
		return

	var direction := Vector2()

	if Input.is_action_pressed("move_forward"):
		direction += Vector2.UP
	elif Input.is_action_pressed("move_backward"):
		direction += Vector2.DOWN

	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT

	character_mover.direction = direction

	sprite.rotation = get_local_mouse_position().angle() + Constants.RADIANS_90

	if direction != Vector2.ZERO and step_timer.is_stopped():
		step_timer.start()
	elif direction == Vector2.ZERO:
		step_timer.stop()


func _input(event):
	if event.is_action_pressed("run"):
		character_mover.run()
	elif event.is_action_pressed("sneak"):
		character_mover.sneak()
	else:
		character_mover.walk()

	if event.is_action_pressed("interact"):
		interaction_system.interact()


func _on_unpaused() -> void:
	_setup_mouse()


func _setup_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_custom_mouse_cursor(pointer_texture)


func _add_scent() -> void:
	var scent := scent_scene.instance() as Scent
	scent.player = self
	scent.global_position = global_position
	scents.push_front(scent)

	get_tree().current_scene.add_child(scent)


func _play_step() -> void:
	audio_player.pitch_scale = rand_range(0.9, 1.1)
	audio_player.play()


func set_has_cable(value: bool) -> void:
	has_cable = value

	if has_cable:
		Events.emit_signal("player_has_cable")
	else:
		Events.emit_signal("player_lost_cable")


func set_current_room_id(value: int) -> void:
	current_room_id = value


func clear_current_interactive() -> void:
	interaction_system.current_interactive = null


func get_annoyance_on_sight() -> int:
	if interaction_system.current_interactive:
		return interaction_system.current_interactive.annoyance_on_sight
	else:
		return 0
