extends Control

const AudioStreamWon = preload("res://audio/Game/end_won.wav")
const AudioStreamLost = preload("res://audio/Game/end_lost.wav")

export var fade_time := 0.3
export var alpha_time := 0.3

var won = true
var background := ImageTexture.new()
var tween := Tween.new()

# TODO: Bind these all as exported paths to allow rearranging
onready var background_sprite := $CanvasLayer/BackgroundSprite as Sprite
onready var label = $CanvasLayer/PanelContainer/VBoxContainer/Label as Label
onready var retry_button := $CanvasLayer/PanelContainer/VBoxContainer/RetryButton
onready var quit_button := $CanvasLayer/PanelContainer/VBoxContainer/QuitButton
onready var annoyance_high_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/StatsList/AnnoyanceHighValue
onready var annoyance_low_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/StatsList/AnnoyanceLowValue
onready var time_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/StatsList/TimeValue
onready var rooms_entered_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/StatsList/RoomsEnteredValue
onready var player_interactions_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/StatsList/PlayerInteractionsValue
onready var mom_interactions_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/StatsList/MomInteractionsValue
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	_set_background()
	_setup_tween()
	_set_stats_labels()
	_play_audio()

	label.text = tr("END_GAME_WIN" if won else "END_GAME_LOSE")

	retry_button.connect("button_up", self, "_on_retry_button_up")
	quit_button.connect("button_up", self, "_on_quit_button_up")


func _setup_tween() -> void:
	add_child(tween)
	tween.interpolate_property(
		background_sprite.material, "shader_param/fade_amount", 0.0, 1.0, fade_time
	)
	tween.interpolate_property(
		background_sprite.material, "shader_param/alpha_amount", 0.0, 1.0, alpha_time
	)
	tween.start()


func _set_background() -> void:
	var image := get_viewport().get_texture().get_data()
	image.flip_y()

	background.create_from_image(image)
	background_sprite.texture = background


func _set_stats_labels() -> void:
	annoyance_high_label.text = str(Stats.annoyance_high)
	annoyance_low_label.text = str(Stats.annoyance_low)
	time_label.text = _formatted_time()
	rooms_entered_label.text = str(Stats.rooms_entered)
	player_interactions_label.text = str(Stats.player_interactions)
	mom_interactions_label.text = str(Stats.mom_interactions)


func _play_audio() -> void:
	audio_player.stream = AudioStreamWon if won else AudioStreamLost
	audio_player.play()


func _formatted_time() -> String:
	var minutes: float = Stats.time / 60
	var seconds: float = fmod(Stats.time, 60)
	var milliseconds: float = fmod(Stats.time, 1) * 100
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]


func _on_retry_button_up() -> void:
	Events.emit_signal("retry")


func _on_quit_button_up() -> void:
	Events.emit_signal("quit")
