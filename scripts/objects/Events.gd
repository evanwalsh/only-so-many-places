# warning-ignore-all:unused_signal
# class_name Events
extends Node

signal player_entered_room(id)
signal player_exited_room(id)
signal player_has_cable
signal player_lost_cable
signal player_interacted

signal mom_entered_room(id)
signal mom_exited_room(id)
signal mom_annoyance_changed(value)
signal mom_state_changed(state)
signal mom_interacted

signal start_game
signal end_game(won)
signal retry
signal quit
signal paused
signal unpaused
