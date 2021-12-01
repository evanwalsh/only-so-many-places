class_name Interactive
extends Node2D

signal interacted
signal interaction_canceled

const GROUP = "interactive"
const InteractiveProgressScene := preload("res://scenes/Interactive/InteractiveProgress.tscn")
const InteractableMaterial := preload("res://materials/outline_interactable.tres")

# Amount of time to wait until interaction is complete
export var translation_name := "UNKNOWN"
export(float, 10.0) var mom_wait_time := 0.0
export(float, 10.0) var player_wait_time := 0.0
export(int) var annoyance_on_sight := 0
export(float, 500.0) var wait_radius := 30.0
export(NodePath) var sprite_path
export var area_path: NodePath

var has_cable := false
var timer: Timer
var progress_bar: InteractiveProgress
var monitor_area: Area2D
var _current_interactors = []

onready var area := get_node(area_path) as Area2D
onready var sprite := get_node_or_null(sprite_path) as Sprite
onready var audio_player := get_node_or_null("AudioStreamPlayer2D") as AudioStreamPlayer2D


static func get_group_name(id: int) -> String:
	return "{group}/area-{id}".format({group = GROUP, id = id})


func _ready() -> void:
	assert(area != null, "You must set an area!")
	add_to_group(GROUP)
	add_to_group(get_group_name(area.get_instance_id()))


func _process(_delta) -> void:
	if timer and progress_bar and !timer.is_stopped():
		progress_bar.value = 100 - (100 * (timer.time_left / timer.wait_time))


func _on_start_interact(_actor: KinematicBody2D, _is_player: bool) -> void:
	DescriptionManager.hide(self)
	if audio_player:
		audio_player.play()


func _on_complete_interact(actor: KinematicBody2D, is_player: bool) -> void:
	if audio_player:
		audio_player.stop()

	if !is_player:
		return

	if _gives_cable(actor):
		DescriptionManager.show(self, "OBJECT_%s_CABLE" % translation_name.to_upper())
	else:
		DescriptionManager.show(self, "OBJECT_%s_NO_CABLE" % translation_name.to_upper())


func _on_cancel_interact(_actor: KinematicBody2D, _is_player: bool) -> void:
	if audio_player:
		audio_player.stop()


func _on_timeout(actor: KinematicBody2D, is_player: bool) -> void:
	_cleanup_children()
	_on_complete_interact(actor, is_player)
	_cleanup_interactor(actor)
	emit_signal("interacted")


func _add_timer(actor: KinematicBody2D, is_player: bool) -> Timer:
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = player_wait_time if is_player else mom_wait_time
	timer.connect("timeout", self, "_on_timeout", [actor, is_player])
	add_child(timer)

	return timer


func _add_progress_bar() -> InteractiveProgress:
	progress_bar = InteractiveProgressScene.instance() as InteractiveProgress
	progress_bar.rotation = -rotation
	add_child(progress_bar)

	return progress_bar


func _add_monitor_area(actor: KinematicBody2D, is_player: bool) -> Area2D:
	monitor_area = Area2D.new()
	var collision_shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()

	circle.radius = wait_radius
	collision_shape.shape = circle
	monitor_area.add_child(collision_shape)
	monitor_area.connect("body_exited", self, "_on_body_exited", [actor, is_player])
	monitor_area.collision_mask = Mask.for_layers([5])

	add_child(monitor_area)

	return monitor_area


func _cleanup_children() -> void:
	if timer:
		timer.disconnect("timeout", self, "_on_timeout")
		timer.queue_free()
		timer = null

	if progress_bar:
		progress_bar.queue_free()
		progress_bar = null

	if monitor_area:
		monitor_area.disconnect("body_exited", self, "_on_body_exited")
		monitor_area.queue_free()
		monitor_area = null


func _add_interactor(actor: KinematicBody2D) -> void:
	_current_interactors.append(actor)


func _is_interacting(actor: KinematicBody2D) -> bool:
	return _current_interactors.has(actor)


func _cleanup_interactor(actor: KinematicBody2D) -> void:
	_current_interactors.erase(actor)

	if actor.has_method("clear_current_interactive"):
		actor.clear_current_interactive()


func _on_body_exited(body: PhysicsBody2D, actor: KinematicBody2D, is_player: bool) -> void:
	if !body or body != actor:
		return

	cancel_interact(actor, is_player)


func interact(actor: KinematicBody2D) -> void:
	if _is_interacting(actor):
		return

	var is_player: bool = actor == Game.player
	var wait_time := player_wait_time if is_player else mom_wait_time

	_add_interactor(actor)
	_on_start_interact(actor, is_player)

	if wait_time > 0:
		if is_player:
			_add_progress_bar()

		_add_timer(actor, is_player).start()
		_add_monitor_area(actor, is_player)
	else:
		_on_complete_interact(actor, is_player)
		_cleanup_interactor(actor)
		emit_signal("interacted")


func cancel_interact(actor: KinematicBody2D, is_player: bool) -> void:
	if timer:
		timer.stop()

	if progress_bar:
		progress_bar.hide()

	_cleanup_interactor(actor)
	_cleanup_children()
	emit_signal("interaction_canceled")
	_on_cancel_interact(actor, is_player)


func set_interactable(value: bool) -> void:
	if !sprite:
		return

	sprite.material = InteractableMaterial if value else null


func _gives_cable(player: KinematicBody2D) -> bool:
	if has_cable:
		player.has_cable = true
		has_cable = false
		return true

	return false
