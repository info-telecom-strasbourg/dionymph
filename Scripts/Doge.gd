extends KinematicBody2D

export var ACCELERATION = 550
export var MAX_SPEED = 100
export var FRICTION = 500

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var animationState = animationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetection
onready var dogRange = $DogRange

enum{
	IDLE,
	FOLLOW
}

var velocity = Vector2.ZERO
var state = IDLE
var player = null
var player_proche = null

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # Friction
			if can_see_player() == false:
				state = FOLLOW
			animationState.travel("Idle")
		
		FOLLOW:
			if player != null:
				animationTree.set("parameters/Idle/blend_position", velocity)
				animationTree.set("parameters/Run/blend_position", velocity)
				animationTree.set("parameters/Sit/blend_position", velocity)
				if player_proche != null:
					state = IDLE
					$Timer.start(2)
				else:
					accelerate_towards_point(player.global_position, delta)
					animationState.travel("Run")
			else:
				state = IDLE
				$Timer.start(2)
	
	velocity = move_and_slide(velocity)

func _ready():
	animationTree.active = true

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func can_see_player():
	return player_proche != null

func _on_DogRange_body_entered(body):
	player = body

func _on_DogRange_body_exited(body):
	player = null

func _on_PlayerDetection_body_entered(body):
	player_proche = body

func _on_PlayerDetection_body_exited(body):
	player_proche = null

func _on_Timer_timeout():
	animationState.travel("Sit")
