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
	ATTACK,
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var can_attack:bool
var direction:Vector2 = Vector2.RIGHT
var player_in_atk_zone = false


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
	var _direction = global_position.direction_to(point)
	velocity = velocity.move_toward(_direction * MAX_SPEED, ACCELERATION * delta)
	update_direction(_direction)

func update_direction(_dir):
	if _dir.x > 0:
		if _dir.y > 0:
			if _dir.y / _dir.x > 0.5:
				direction = Vector2.DOWN
			else:
				direction = Vector2.RIGHT
		elif _dir.y < 0:
			if -_dir.y / _dir.x > 0.5:
				direction = Vector2.UP
			else:
				direction = Vector2.RIGHT
	elif _dir.x < 0:
		if _dir.y > 0:
			if _dir.y / _dir.x > 0.5:
				direction = Vector2.DOWN
			else:
				direction = Vector2.LEFT
		elif _dir.y < 0:
			if -_dir.y / _dir.x > 0.5:
				direction = Vector2.UP
			else:
				direction = Vector2.LEFT

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
		player_in_atk_zone = true
		randomizeAttack()


func randomizeAttack():
	if state == ATTACK:
		attacks.shuffle()
		update_direction(global_position.direction_to(player.global_position))
		call_deferred(attacks[0])

func _on_AttackZone_body_exited(body):
	player_in_atk_zone = false


func _on_PlayerDetectionZone_body_entered(body):
	state = CHASE
	player = body


func _on_PlayerDetectionZone_body_exited(body):
	player = null
	state = pick_random_state([IDLE, WANDER])

func attack1():
	yield(get_tree(), "idle_frame")
	$Attack1.monitoring = true
	$Attack1.monitorable = true
	$Attack1.rotation = atan2(global_position.y - player.global_position.y, global_position.x - player.global_position.x) + PI
	$Attack1/AnimationPlayer.play("Attack1Anim")
	if direction in [Vector2.RIGHT, Vector2.LEFT]:
		$AnimationPlayer.play("AttackRight")
	elif direction == Vector2.UP:
		$AnimationPlayer.play("AttackUp")
	elif direction == Vector2.DOWN:
		$AnimationPlayer.play("AttackDown")
	if not $Attack1/AnimationPlayer.is_connected("animation_finished", self, "on_anim_finished"):
		$Attack1/AnimationPlayer.connect("animation_finished", self, "on_anim_finished", [$Attack1/AnimationPlayer])

func attack2():
	yield(get_tree(), "idle_frame")
	yield(get_tree().create_timer(0.5), "timeout")
	$Attack2.monitoring = true
	$Attack2.monitorable = true
	yield(get_tree().create_timer(0.1), "timeout")
	$Attack2.monitoring = false
	$Attack2.monitorable = false
	$AttackCooldown.start(1.0)

func attack3():
	yield(get_tree(), "idle_frame")
	$attack3.monitoring = true
	$attack3.monitorable = true
	$attack3/AnimationPlayer.play("attack3animation")
	$attack3/AnimationPlayer.connect("animation_finished", self, "on_anim_finished", [$attack3/AnimationPlayer, 1.0])

func attack4():
	yield(get_tree(), "idle_frame")
	$attack4.monitoring = true
	$attack4.monitorable = true
	$attack4/AnimationPlayer.play("Nouvelle animation")
	$attack4/AnimationPlayer.connect("animation_finished", self, "on_anim_finished", [$attack4/AnimationPlayer, 0.5])
	
func attack5():
	yield(get_tree(), "idle_frame")
	$Attack5.monitoring = true
	$Attack5.monitorable = true
	$Attack5/AnimationPlayer.play("Attack5animation")
	$Attack5/AnimationPlayer.connect("animation_finished", self, "on_anim_finished", [$Attack5/AnimationPlayer, 0.5])
	
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
	$AttackCooldown.start(0.5)

func attack7():
	$attack7.monitoring = true
	$attack7.monitorable = true
	$attack7/AnimationPlayer.play("Attack7animation")
	$attack7/AnimationPlayer.connect("animation_finished", self, "on_anim_finished", [$attack7/AnimationPlayer, 0.5])


func _on_AttackCooldown_timeout():
	if player_in_atk_zone:
		randomizeAttack()
	else:
		state = CHASE

func on_anim_finished(anim_name, node:AnimationPlayer, delay:float = 1.0):
	node.disconnect("animation_finished", self, "on_anim_finished")
	node.get_parent().monitoring = false
	node.get_parent().monitorable = false
	$AttackCooldown.start(delay)
