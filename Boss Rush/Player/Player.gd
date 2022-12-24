extends KinematicBody2D

export var max_speed:int

onready var animationTree := $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var timer := $InputBuffer

var velocity:Vector2
var last_input_direction:Vector2
var tasks:Array = []
var mouse_click_position: Vector2

func _ready() -> void:
	animationTree.active = true

func _physics_process(delta: float) -> void:
	if tasks.empty():
		move(delta)
		velocity = move_and_slide(velocity)
		return
		
	if tasks.front() == "attack":
		attack(mouse_click_position)
	if tasks.front() == "roll":
		pass
	
func get_input() -> Vector2:
	var input_vector:Vector2
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Attack"):
		queue_task("attack")
		mouse_click_position = get_local_mouse_position()
		last_input_direction = mouse_click_position.normalized()
	
func move(delta: float) -> void:
	velocity = get_input() * max_speed
	move_animation()
	
func set_animation(animation_2Dblend_name:String, blend_vector:Vector2) -> void:
	animationState.travel(animation_2Dblend_name)
	animationTree.set("parameters/" + animation_2Dblend_name + "/blend_position", blend_vector)
	
func attack(mouse_position) -> void:
	velocity = Vector2.ZERO
	set_animation("Attack", mouse_position)
	
func attack_animation_finished() -> void:
	tasks.pop_front()
	print("animation finished")

func move_animation() -> void:
	if get_input() != Vector2.ZERO:
		set_animation("Walk", get_input())
		last_input_direction = get_input()
	else:
		set_animation("Idle", last_input_direction)

func queue_task(task):
	tasks.push_back(task)

func _on_InputBuffer_timeout() -> void:
	#tasks.clear()
	#to test clearing task queue
	pass
