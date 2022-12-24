extends HBoxContainer

signal change_button_pressed

func initialize(action_name:String, key, can_change:bool):
	$Action.text = action_name.capitalize()
	$Key.text = OS.get_scancode_string(key)
	$ChangeButton.disabled = not can_change
	
func update_key(scancode):
	$Key.text = OS.get_scancode_string(scancode)


func _on_ChangeButton_pressed() -> void:
	emit_signal("change_button_pressed")
