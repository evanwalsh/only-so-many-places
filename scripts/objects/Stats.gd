# class_name Stats
extends Node

var tracking := false
var time := 0.0
var annoyance_low := 100
var annoyance_high := 0
var player_interactions := 0
var mom_interactions := 0
var rooms_entered := 0 setget , get_rooms_entered

var _rooms_entered_list = []


func _ready() -> void:
	Events.connect("start_game", self, "_on_start_game")
	Events.connect("end_game", self, "_on_end_game")
	Events.connect("mom_annoyance_changed", self, "_on_mom_annoyance_changed")
	Events.connect("player_entered_room", self, "_on_player_entered_room")
	Events.connect("player_interacted", self, "_on_player_interacted")
	Events.connect("mom_interacted", self, "_on_mom_interacted")


func _process(delta: float) -> void:
	time += delta


func _on_start_game() -> void:
	tracking = true
	reset()


func _on_end_game(_won: bool) -> void:
	tracking = false


func _on_mom_annoyance_changed(value: int) -> void:
	if value > annoyance_high:
		annoyance_high = value

	if value < annoyance_low:
		annoyance_low = value


func _on_player_entered_room(id: int) -> void:
	if !_rooms_entered_list.has(id):
		_rooms_entered_list.append(id)


func _on_player_interacted() -> void:
	player_interactions += 1


func _on_mom_interacted() -> void:
	mom_interactions += 1


func get_rooms_entered() -> int:
	return _rooms_entered_list.size()


func reset() -> void:
	time = 0.0
	annoyance_low = 100
	annoyance_high = 0
	rooms_entered = 0
	player_interactions = 0
	mom_interactions = 0
