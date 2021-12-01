class_name RoomArea
extends Area2D

enum ID {
	UNKNOWN,
	BALCONY,
	BATHROOM,
	HALLWAY,
	KITCHEN,
	LIVING_ROOM,
	MOM_BATHROOM,
	MOM_BEDROOM,
	MY_ROOM,
}

export(ID) var id := ID.UNKNOWN
export var allowed := true
export(int, 0, 100) var annoyance_per_tick := 0

var label setget , get_label


static func get_label_from_id(room_area_id: int) -> String:
	return TranslationServer.translate("ROOM_NAME_%s" % ID.keys()[room_area_id])


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func get_label() -> String:
	return get_label_from_id(id)


func _on_body_entered(body: PhysicsBody2D) -> void:
	if !body:
		return

	if body == Game.player:
		Game.player.current_room_id = id
		Events.emit_signal("player_entered_room", id)
	elif body == Game.mom:
		Game.mom.current_room_id = id
		Events.emit_signal("mom_entered_room", id)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if !body:
		return

	if body == Game.player:
		Events.emit_signal("player_exited_room", id)
	elif body == Game.mom:
		Events.emit_signal("mom_exited_room", id)
