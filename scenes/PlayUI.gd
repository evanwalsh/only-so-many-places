extends Control

onready var room_label := $Canvas/LeftData/RoomLabel as Label
onready var annoyance_value_label := $Canvas/PanelContainer/Annoyance/Value
onready var objective_label := $Canvas/LeftData/ObjectiveLabel as Label


func _ready():
	Events.connect("player_entered_room", self, "_on_player_entered_room")
	Events.connect("mom_annoyance_changed", self, "_on_mom_annoyance_changed")
	Events.connect("player_has_cable", self, "_on_player_has_cable")

	if Game.player:
		_on_player_entered_room(Game.player.current_room_id)


func _on_mom_annoyance_changed(value: int) -> void:
	annoyance_value_label.text = "%d / 100" % value


func _on_player_entered_room(id: int) -> void:
	room_label.text = RoomArea.get_label_from_id(id)


func _on_player_has_cable() -> void:
	objective_label.text = tr("OBJECTIVE_END_GAME")
	objective_label.add_color_override(
		"font_color", Color(251.0 / 255.0, 242.0 / 255.0, 54.0 / 255.0)
	)


func set_visible(value: bool) -> void:
	visible = value
