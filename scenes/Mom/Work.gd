extends State

const MAX_SEEK_TIME := 8.0

export var pause_timeout := 3.0

var destination: Interactive setget _set_destination
var timer: Timer
var interacting := false

onready var mom := owner


func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = MAX_SEEK_TIME
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)


func enter() -> void:
	mom.should_work = false

	_set_destination(mom.get_patrol_destination())
	interacting = false


func exit() -> void:
	pass


func update(delta: float) -> void:
	# FIXME: This whole function is kind of a mess
	if interacting:
		mom.stop_moving()
		return

	if mom.interaction_system.can_interact_with(destination) and !interacting:
		mom.interaction_system.interact()
		interacting = true
		timer.stop()

		if destination.mom_wait_time > 0:
			yield(destination, "interacted")

		interacting = false
		mom.step_patrol()
		_set_destination(mom.get_patrol_destination())

		if mom.should_chase_player():
			_look_around()
			return

		yield(get_tree().create_timer(pause_timeout), "timeout")
	elif !interacting and mom.player_sighted and mom.should_chase_player():
		emit_signal("finished", "chase")

	mom.vision_system.face_point(mom.global_position + mom.character_mover.direction, delta)
	mom.move_toward_point(destination.global_position)


func _look_around() -> void:
	mom.should_work = true
	emit_signal("finished", "look_around")


func _set_destination(value: Interactive) -> void:
	destination = value
	timer.start()


func _on_timeout() -> void:
	# Sometimes, mom just gets stuck. Let's try to avoid that, yeah?
	if !interacting:
		mom.step_patrol()
		_set_destination(mom.get_patrol_destination())
