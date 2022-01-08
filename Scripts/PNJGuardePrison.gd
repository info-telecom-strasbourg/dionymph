extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 80
export var FRICTION = 450

enum {
	MOVE,
	IDLE
}

var state = IDLE
var velocity = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var timer = $Timer

var point_A = Vector2(-450,-225)
var point_B = Vector2(-120,-70)

var chemin = true

func _ready():
	animationTree.active = true
	timer.start(6)

func _physics_process(delta):
	match state:
		IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		MOVE:
			if chemin:
				move_state(point_A, delta)
				if global_position.distance_to(point_A) <= 4:
					state = IDLE
					chemin = !chemin
					timer.start(5)
			else:
				move_state(point_B, delta)
				if global_position.distance_to(point_B) <= 4:
					state = IDLE
					chemin = !chemin
					timer.start(5)

func move_state(to_point, delta):
	var movement_vector = Vector2.ZERO
	movement_vector = movement_vector.normalized()
	accelerate_towards_point(to_point, delta)
	movement_vector = velocity
	
	if movement_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", movement_vector)
		animationTree.set("parameters/Run/blend_position", movement_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(movement_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func _on_Timer_timeout():
	state = MOVE
