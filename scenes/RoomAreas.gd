class_name RoomAreas
extends Node2D

onready var areas = {
	RoomArea.ID.HALLWAY: $Hallway,
	RoomArea.ID.KITCHEN: $Kitchen,
	RoomArea.ID.LIVING_ROOM: $LivingRoom,
	RoomArea.ID.MY_ROOM: $MyRoom,
	RoomArea.ID.BALCONY: $Balcony,
	RoomArea.ID.BATHROOM: $Bathroom,
	RoomArea.ID.MOM_BATHROOM: $MomBathroom,
	RoomArea.ID.MOM_BEDROOM: $MomBedroom,
}


func _ready():
	pass
