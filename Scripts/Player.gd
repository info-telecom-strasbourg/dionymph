extends KinematicBody2D

onready var game = get_node("/root/Game")
signal interact
signal interact_finish
const PlayerHurtSound = preload("res://Scenes/PlayerHurtSound.tscn")

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
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var hurtbox = $Hurtbox

func _ready():
	randomize() # Permet de forcer le jeu à générer un seed pour outpass le pseudo random 
				# dans tous le code et ce dès le début de chaque scène où il y a Player
	$Light2D.visible = true
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	$HitboxPivot/SwordHitbox/CollisionShape2D.disabled = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	if is_instance_valid(game.NPC_dialogue):
		return
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: # When moving
		roll_vector = input_vector # Effectue une roulade dans le même sens que la course
		swordHitbox.knockback_vector = input_vector
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
	hurtbox.start_invincibility(0.1)
	velocity = roll_vector * ROLL_SPEED # Attribue un vecteur au mvmt roulade
	animationState.travel("Roll") # Passe de Run/Idle à Roll dans AnimationTree pour jouer l'animation
	move() # Effectue le déplacement

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")


### Fin des animations et changements d'états vers Idle/Run
func roll_animation_finished():
	velocity = velocity / 4
	state = MOVE

func attack_animation_finished():
	state = MOVE


### Hurtbox
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("stop")

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hitEffect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	# Pas besoin de lancer car en Autoplay



### Key Prompt - Enter house

var house = null setget set_house

func set_house(new_house):
	if new_house:
		$InteractionKey.show()
		$KeyPrompt.play("KeyPrompt")
	else:
		$InteractionKey.hide()
		$KeyPrompt.stop()
	
	house = new_house

func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("interaction") and house != null:
		if house.inside_house == null :
			print("No inside_house loaded, or empty")
		else:
			Global.player_pos = global_position
			house.enter()

func _on_NPCHitbox_area_entered(area):
	if area.get_parent() is KinematicBody2D:
		emit_signal("interact", area.get_parent().id, tr("PARLER"))
	else:
		emit_signal("interact", area.id, tr("OUVRIR"))

func _on_NPCHitbox_area_exited(area):
	emit_signal("interact_finish")
