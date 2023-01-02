extends Node

signal input_profile(new_profile, is_customizable)

var profile_default = {
	'move_up': KEY_W,
	'move_down': KEY_S,
	'move_left': KEY_A,
	'move_right': KEY_D,
	'Roll' : KEY_SPACE
}

var profile_custom = profile_default

func create_or_load_input_profile(id):
	#to be changed in the future with saving capabilities
	var input_map = (profile_default)
	var is_customizable = true
	
	for action_name in input_map.keys():
		change_action_key(action_name, input_map[action_name])
	emit_signal("input_profile", input_map, is_customizable)
	return input_map
	
func reset_to_default_input_profile(id):
	create_or_load_input_profile(id)

func change_action_key(action_name, key_scancode) -> void:
	erase_action_events(action_name)
	
	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)

func erase_action_events(action_name) -> void:
	var input_events = InputMap.get_action_list(action_name)
	#input_events = input_events.action_erase_events(action_name)
	#does'nt work for some reason
	for event in input_events:
		InputMap.action_erase_event(action_name, event)
	
	
