extends KinematicBody2D

# Variables accessibles dans l'onglet à droite en sélectionnant Player.tscn
export var ACCELERATION = 500
export var MAX_SPEED = 100
export var ROLL_SPEED = 140
export var FRICTION = 500

# Enum pour machine état des animations du joueur
enum {
	MOVE,   # State 0
	ROLL,   # State 1
	ATTACK  # State 2
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN # Initialement Player regarde vers le bas
#var stats = $PlayerStats # Singleton Autoload

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: # When moving
		roll_vector = input_vector # Effectue une roulade dans le même sens que la course
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	# Roulade/Esquive (non implémentée -> idée enlever temporairement hitbox)
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func move():
	velocity = move_and_slide(velocity)

# Actions de l'utilisateur
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED # Attribue un vecteur au mvmt roulade
	animationState.travel("Roll") # Passe de Run/Idle à Roll dans AnimationTree pour jouer l'animation
	move() # Effectue le déplacement

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

# Fin des animations et changements d'états vers Idle/Run
func roll_animation_finished():
	velocity = velocity / 4
	state = MOVE

func attack_animation_finished():
	state = MOVE
