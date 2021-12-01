extends StateMachine


func _ready() -> void:
	states_map = {
		idle = $Idle, chase = $Chase, search = $Search, look_around = $LookAround, work = $Work
	}

	connect("state_changed", self, "_on_state_changed")


func _on_state_changed(state: State) -> void:
	Events.emit_signal("mom_state_changed", state)
