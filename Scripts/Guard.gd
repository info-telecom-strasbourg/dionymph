extends Enemy

func _ready():
	ACCELERATION = 500
	MAX_SPEED = 40
	FRICTION = 200
	can_attack = true
	attacks =["attack1","attack2","attack3"]
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # Friction
			if wander_controler.get_time_left() == 0:
				update_wander()
		
		WANDER:
			if wander_controler.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wander_controler.target_position,delta)
			if global_position.distance_to(wander_controler.target_position) <= 4:
				update_wander()
			
		CHASE:
			if player != null:
				# Bouger vers player
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	# Si deux Bats (ou autre entité avec SoftCollision) trop proches, les éloignent
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)
