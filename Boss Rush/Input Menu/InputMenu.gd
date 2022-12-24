extends Control

onready var action_list = get_node("VBoxContainer/ScrollContainer/ActionList")
onready var input_mapper = $InputMapper

var paused:bool = false

func _ready() -> void:
	close()
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	input_mapper.connect("input_profile", self, "rebuild")
	input_mapper.create_or_load_input_profile(input_mapper.profile_default)

func rebuild(input_profile, is_customizable:bool = false):
	action_list.clear()
	for input_action in input_profile.keys():
		var line = action_list.add_input_line(input_action, \
			input_profile[input_action], is_customizable)
		if is_customizable:
			line.connect("change_button_pressed", self, \
			"_on_InputLine_change_button_pressed", [input_action, line])

func _on_InputLine_change_button_pressed(action_name, line):
	set_process_input(false)
	
	$ListeningForEvent.open()
	var key_scancode = yield($ListeningForEvent, "key_selected")
	$InputMapper.change_action_key(action_name, key_scancode)
	line.update_key(key_scancode)
	
	set_process_input(true)
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause Menu"):
		if paused:
			close()
	

func open() -> void:
	get_tree().set_input_as_handled()
	get_tree().paused = true
	paused = true
	show()
	set_process_input(true)

func close() -> void:
	get_tree().paused = false
	paused = false
	hide()
	set_process_input(false)
	get_tree().set_input_as_handled()


func _on_Back_to_Game_pressed() -> void:
	close()

func _on_Reset_to_Default_pressed() -> void:
	input_mapper.reset_to_default_input_profile(input_mapper.profile_default)
