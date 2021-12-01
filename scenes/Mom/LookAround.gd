extends State

export(float, 0, 30) var time := 2.0
export(float, 0, 2.0) var rotation_time := 0.5

var timer: Timer = null
var tween: Tween = null

onready var mom := owner as Mom


func _ready() -> void:
	pass


func enter() -> void:
	add_timer().start()
	add_tween()

	rotate()


func exit() -> void:
	timer.stop()
	timer.queue_free()

	tween.stop(mom)
	tween.queue_free()


func stop() -> void:
	if mom.should_work:
		emit_signal("finished", "work")
	else:
		mom.play_status_stream(mom.StatusStreamLostPlayer)
		emit_signal("finished", "idle")


func update(_delta: float) -> void:
	mom.stop_moving()
	mom.player_sighted = mom.sees_player()

	if mom.player_sighted:
		emit_signal("finished", "chase")


func add_timer() -> Timer:
	timer = Timer.new()
	timer.wait_time = time
	timer.connect("timeout", self, "stop")
	add_child(timer)

	return timer


func add_tween() -> Tween:
	tween = Tween.new()
	add_child(tween)

	return tween


func tween_rotate(start: float, end: float, delay: float = 0) -> void:
	tween.interpolate_property(
		mom, "sprite:rotation", start, end, rotation_time, Tween.TRANS_BACK, Tween.EASE_OUT, delay
	)

	tween.start()


func rotate() -> void:
	var initial_rotation := mom.sprite.rotation
	var first_rotation := deg2rad(randi() % 55 + 35)
	var second_rotation := deg2rad(randi() % 55 + 35)

	tween_rotate(initial_rotation, initial_rotation - first_rotation)
	yield(tween, "tween_completed")

	tween_rotate(mom.sprite.rotation, initial_rotation + second_rotation, 0.25)
	yield(tween, "tween_completed")

	tween_rotate(mom.sprite.rotation, initial_rotation + second_rotation + first_rotation, 0.25)
