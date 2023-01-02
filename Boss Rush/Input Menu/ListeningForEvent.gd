extends Panel

signal key_selected(key_scancode)

func _ready() -> void:
	set_process_input(false)
	
func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	if event is InputEventMouseButton:
		#if true, the game crashes. if emitted as a scancode, the command doesn't work
		#Don't know what to do but current implementation is good enough
		pass
	else:
		emit_signal("key_selected", event.scancode)
	close()
	
func open() -> void:
	show()
	set_process_input(true)

func close() -> void:
	hide()
	set_process_input(false)
