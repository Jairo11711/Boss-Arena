extends KinematicBody2D

export var max_speed:int

onready var animationPlayer := $AnimationPlayer
onready var animationTree := $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var timer := $InputBuffer

enum {
	HAS_TASK,
	NO_TASK
}

var velocity:Vector2
var last_input_direction:Vector2
var tasks:Array = []
var mouse_click_position: Vector2
var state = NO_TASK

func _ready() -> void:
	animationTree.active = true

func _physics_process(delta: float) -> void:
	if tasks.empty():
		state = NO_TASK
	else:
		state = HAS_TASK
	
	match state:
		NO_TASK:
			move(delta)
		HAS_TASK:
			do_tasks()
		
	velocity = move_and_slide(velocity)
	
func get_input() -> Vector2:
	var input_vector:Vector2
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()

func create_task(task_name:String, direction:Vector2):
	if !timer.time_left > 0:
		timer.start()
		
	var attack_command = AttackCommand.new()
	attack_command.task_name = task_name
	attack_command.mouse_direction = direction
	
	return attack_command

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Attack"):
		last_input_direction = get_local_mouse_position().normalized()
		queue_task(create_task("attack", get_local_mouse_position().normalized()))
		
	if Input.is_action_just_pressed("Roll"):
		queue_task(create_task("roll", last_input_direction))
	
func move(delta: float) -> void:
	velocity = get_input() * max_speed
	move_animation()
	
func set_animation(animation_2Dblend_name:String, blend_vector:Vector2) -> void:
	animationState.travel(animation_2Dblend_name)
	animationTree.set("parameters/" + animation_2Dblend_name + "/blend_position", blend_vector)
	
func attack(mouse_position) -> void:
	velocity = Vector2.ZERO
	set_animation("Attack", mouse_position)
	
func roll(mouse_position) -> void:
	var roll_speed = 2.0 / 0.7
	var roll_direction = mouse_position
	velocity = roll_direction * max_speed * roll_speed
	set_animation("Roll", mouse_position)
	
func attack_animation_finished() -> void:
	tasks.pop_front()

func move_animation() -> void:
	if get_input() != Vector2.ZERO:
		set_animation("Walk", get_input())
		last_input_direction = get_input()
	else:
		set_animation("Idle", last_input_direction)

func do_tasks():
	if tasks.empty():
		state = NO_TASK
		return
	
	if tasks.front().task_name == "attack":
		attack(tasks.front().mouse_direction)
	if tasks.front().task_name == "roll":
		roll(tasks.front().mouse_direction)
		
	if tasks.front().task_name == "clear_queue": 
		tasks.clear()
	
func queue_task(task):
	tasks.push_back(task)

func _on_InputBuffer_timeout() -> void:
	var task = AttackCommand.new()
	task.task_name = "clear_queue"
	queue_task(task)
