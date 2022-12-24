extends Panel

signal key_selected(key_scancode)

func _ready() -> void:
	set_process_input(false)
	
func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	emit_signal("key_selected", event.scancode)
	close()
	
func open() -> void:
	show()
	set_process_input(true)

func close() -> void:
	hide()
	set_process_input(false)
