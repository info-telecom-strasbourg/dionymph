extends KinematicBody2D

var JUMP_NUM:int = 1
var GRAVITY:float = 7 
var JUMP_INITIAL_STRENGTH:float = 175 #235
var MOVE_SPEED:float = 100
var spawn:Vector2
var velocity:Vector2 = Vector2.ZERO
var num_jumps:int = 1
var score:int
var deaths:int = 0

var air_jump:bool = false

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if Input.is_action_pressed("A"):
		velocity.x = -MOVE_SPEED
	elif Input.is_action_pressed("D"):
		velocity.x = MOVE_SPEED
	else:
		velocity.x = 0
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		if get_slide_collision(i).collider.name == "Killers":
			deaths += 1
			reset_map()
	if is_on_floor():
		num_jumps = JUMP_NUM

func reset_map():
	position = spawn
	for node in get_parent().get_children():
		if node is Fruit:
			node.visible = true
	air_jump = false
	score = 0
	get_node("../Score").text = "0"

func _input(_event):
	if Input.is_action_just_pressed("jump") and _can_jump():
		num_jumps -= 1
		velocity.y = -JUMP_INITIAL_STRENGTH
	if Input.is_action_just_pressed("A"):
		$Sprite.set_flip_h(true)
	if Input.is_action_just_pressed("D"):
		$Sprite.set_flip_h(false)


func _can_jump():
	if num_jumps > 0:
		if is_on_floor():
			return true
		elif air_jump:
			return true
	return false
