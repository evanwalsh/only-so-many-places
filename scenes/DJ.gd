extends Node

const SILENCE_VOLUME := -60.0

export(float, -80.0, 24.0) var volume := -18.0
export(float, 0.0) var fade_time := 0.25
export(float, 0.0) var end_game_fade_time := 0.5
export(float, 0.0) var end_game_pitch_scale := 0.75

onready var stealth_player := $StealthPlayer as AudioStreamPlayer
onready var chase_player := $ChasePlayer as AudioStreamPlayer
onready var tween := $Tween as Tween


func _ready() -> void:
	stealth_player.volume_db = volume
	chase_player.volume_db = SILENCE_VOLUME

	Events.connect("mom_state_changed", self, "_on_mom_state_changed")
	Events.connect("end_game", self, "_on_end_game")


func _on_mom_state_changed(state: State) -> void:
	var fade_in := stealth_player
	var fade_out := chase_player

	tween.stop(fade_in)
	tween.stop(fade_out)

	var play_chase := state.name == "Chase" or state.name == "Search"

	if play_chase:
		if chase_player.volume_db >= volume:
			return

		fade_in = chase_player
		fade_out = stealth_player

	tween.interpolate_property(
		fade_in, "volume_db", fade_in.volume_db, volume, fade_time, Tween.TRANS_QUAD
	)
	tween.interpolate_property(
		fade_out, "volume_db", fade_out.volume_db, SILENCE_VOLUME, fade_time, Tween.TRANS_QUAD
	)
	tween.start()


func _on_end_game(won: bool) -> void:
	if won:
		stealth_player.volume_db = volume
		chase_player.volume_db = SILENCE_VOLUME
	else:
		chase_player.volume_db = volume
		chase_player.pitch_scale = end_game_pitch_scale
		stealth_player.volume_db = SILENCE_VOLUME
