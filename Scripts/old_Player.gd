extends KinematicBody2D

var max_speed:float = 300
var acceleration:float = 3600
var friction:float = 3600
var velocity = Vector2.ZERO
var attacking:bool = false

func _ready():
	pass

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	if OS.get_latin_keyboard_variant() == "AZERTY":
		input_vector.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("Q"))
		input_vector.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("Z"))
	else:
		input_vector.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
		input_vector.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)

func _unhandled_input(event):
	if Input.is_action_just_pressed("left_click"):
		attacking = true

func _input(event):
	if Input.is_action_just_released("left_click"):
		attacking = false
