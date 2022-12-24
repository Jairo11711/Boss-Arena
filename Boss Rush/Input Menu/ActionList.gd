extends VBoxContainer

const INPUT_LINE = preload("res://Input Menu/InputLine.tscn")

func clear() -> void:
	for child in get_children():
		child.queue_free()
		
func add_input_line(action_name:String, key, is_cuztomizable:bool = false) -> PackedScene:
	var line = INPUT_LINE.instance()
	line.initialize(action_name, key, is_cuztomizable)
	add_child(line)
	return line
	
