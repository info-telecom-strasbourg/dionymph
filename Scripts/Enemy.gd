class_name Enemy
extends KinematicBody2D

const EnnemyDeathEffect = preload("res://Scenes/EnnemyDeathEffect.tscn")

var ACCELERATION
var MAX_SPEED
var FRICTION

enum{
	IDLE,
	WANDER, 
	CHASE,
	ATTACK
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var can_attack:bool


var state = CHASE
var attacks:Array 
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var attack_zone = $AttackZone
onready var wander_controler = $WanderController
onready var BlinkAnimationPlayer = $BlinkAnimationPlayer

var player = null

func _ready():
	state = pick_random_state([IDLE, WANDER])

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controler.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list): # Array
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hitEffect()
	hurtbox.start_invincibility(0.4)

func _on_Hurtbox_invincibility_started():
	BlinkAnimationPlayer.play("start")

func _on_Hurtbox_invincibility_ended():
	BlinkAnimationPlayer.play("stop")

func _on_Stats_no_health():
	queue_free()
	var ennemyDeathEffect = EnnemyDeathEffect.instance()
	get_parent().add_child(ennemyDeathEffect)
	ennemyDeathEffect.global_position = global_position


func _on_AttackZone_body_entered(body):
	if can_attack:
		state = ATTACK
		while state == ATTACK:
			attacks.shuffle()
			call(attacks[0])
			
		
		


func _on_AttackZone_body_exited(body):
	state = CHASE
	


func _on_PlayerDetectionZone_body_entered(body):
	state = CHASE
	player = body


func _on_PlayerDetectionZone_body_exited(body):
	player = null
	state = pick_random_state([IDLE, WANDER])

func attack1():
	$Attack1.monitoring = true
	$Attack1.rotation = atan2(global_position.y - player.global_position.y, global_position.x - player.global_position.x) + PI
	$Attack1/AnimationPlayer.play("Attack1Anim")

func attack2():
	yield(get_tree().create_timer(0.5), "timeout")
	$Attack2.monitoring = true

func attack3():
	$Attack3.monitoring = true
	$attack3/AnimationPlayer.play("attack3animation")
	yield($attack3/AnimationPlayer,"animation_finished")
	$Attack3.monitoring = false
	yield(get_tree().create_timer(0.5), "timeout")
	
func attack4():
	$Attack4.monitoring = true
	$attack4/AnimationPlayer.play("Nouvelle animation")
	yield($attack4/AnimationPlayer,"animation_finished")
	$attack4.monitoring = false
	yield(get_tree().create_timer(0.5), "timeout")
	
func attack5():
	$Attack5.monitoring = true
	$attack5/AnimationPlayer.play("Attack5animation")
	yield($attack5/AnimationPlayer,"animation_finished")
	$attack5.monitoring = false
	yield(get_tree().create_timer(0.5), "timeout")
	
func attack6():
	var dur = 1
	for k in 5:
		var bombe = preload("res://Scenes/Bombe.tscn").instance()
		get_parent().add_child(bombe)
		bombe.position = position 
		var cible:Vector2 = polar2cartesian (rand_range(8,33), rand_range(0,2*PI))
		var tween:Tween = Tween.new()
		add_child(tween)
		tween.interpolation_property(bombe, "position", null, cible,dur )

func _on_AnimationPlayer_animation_finished(anim_name):
	yield(get_tree().create_timer(0.5), "timeout")
	if state == ATTACK:
		attack1()
