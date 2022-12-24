extends Node2D

func InputHandler():
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	elif Input.is_action_just_pressed("Interact"):
		interact()

func _process(delta: float) -> void:
	InputHandler()

func shoot():
	print("shoot")

func interact():
	print("interacted")
