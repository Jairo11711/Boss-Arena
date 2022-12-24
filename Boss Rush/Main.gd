extends Node2D

const INPUT_MENU = preload("res://Input Menu/InputMenu.tscn")
onready var pause_menu := $CanvasLayer/InputMenu

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause Menu"):
		pause_menu.open()
