class_name StateMachine
extends Node

signal state_changed(current_state)

export(NodePath) var start_state

var states_map := {}
var states_stack := []
var current_state = null
var active = false setget set_active


func _ready() -> void:
	for child in get_children():
		child.connect("finished", self, "_change_state")


func _enter_tree():
	initialize(start_state)


func initialize(start) -> void:
	set_active(true)
	states_stack.push_front(get_node(start))
	current_state = states_stack[0]
	current_state.enter()


func set_active(value: bool) -> void:
	active = value
	set_physics_process(active)
	set_process_input(active)
	if not active:
		states_stack = []
		current_state = null


func _input(event) -> void:
	current_state.handle_input(event)


func _physics_process(delta) -> void:
	current_state.update(delta)


func _on_animation_finished(anim_name):
	if not active:
		return

	current_state.on_animation_finished(anim_name)


func _change_state(state_name):
	if not active:
		return

	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]

	current_state = states_stack[0]
	emit_signal("state_changed", current_state)

	if state_name != "previous":
		current_state.enter()
