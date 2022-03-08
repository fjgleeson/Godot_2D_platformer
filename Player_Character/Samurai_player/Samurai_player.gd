extends KinematicBody2D
signal health_updated(health)
const UP = Vector2(0, -0.5)

const GRAVITY = 14

const MAXFALLSPEED = 200

const MAXSPEED = 150

const ACCEL = 20

const JUMP = 300

export (float) var max_health = 1

onready var health = max_health setget _set_health

var motion = Vector2()

var facing_right = true

var isAttacking = false

var jumps = 0

var is_jumping = false

func damage(amount):
	_set_health(health - amount)

func kill():
	pass
	
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		

func _ready():
	pass # Replace with function body.
	
	
func contact():
		damage(1)
		
func _physics_process(delta):
	
	
	if health == 1:
		motion.y += GRAVITY
		
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED
		
		if facing_right == true:
			$AnimatedSprite.scale.x = 1
			
		else:
			$AnimatedSprite.scale.x = -1
			#$Slash/CollisionShape2D.position.x = $Slash/CollisionShape2D.position.x * -1
			
			
		
		motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
		
		if Input.is_action_pressed("right") && isAttacking == false:
			motion.x += ACCEL
			facing_right = true
			$AnimatedSprite.play("run")
			$Slash/CollisionShape2D.disabled = true
			
		elif Input.is_action_pressed("left") && isAttacking == false:
			motion.x -= ACCEL
			facing_right = false
			$AnimatedSprite.play("run")
			$Slash/CollisionShape2D.disabled = true
		else:
			motion.x = lerp(motion.x,0,0.2)
			#motion.x = 0;
			
			if (isAttacking == false):
				$AnimatedSprite.play("idle")
				$Slash/CollisionShape2D.disabled = true
		if Input.is_action_just_pressed("mouse_left_click"):
			if is_jumping == false:
				if(facing_right == false):
					isAttacking = true
					#$Slash/CollisionShape2D.position.x = $Slash/CollisionShape2D.position.x * -1
					$AnimatedSprite.play("attack1")
				
					$Slash/CollisionShape2D.disabled = false
				else:
					isAttacking = true
					$AnimatedSprite.play("attack1")
				
					$Slash/CollisionShape2D.disabled = false
				
				
		if Input.is_action_just_pressed("mouse_right_click"):
			if is_jumping == false:
				$AnimatedSprite.play("attack2")
				isAttacking = true
				$Slash/CollisionShape2D.disabled = false
			
			
		if is_on_floor():
			is_jumping = false
			if Input.is_action_just_pressed("jump"):
				motion.y = -JUMP
				if jumps > 0:
					jumps = 0
		if !is_on_floor():
			if motion.y <0:
				is_jumping = true
				$AnimatedSprite.play("jump")
			elif motion.y > 0:
				is_jumping = true
				$AnimatedSprite.play("fall")
				
				
			if jumps == 0:
				if Input.is_action_just_pressed("jump"):
					is_jumping = true
					$AnimatedSprite.play("jump")
					motion.y = -JUMP
					jumps = 1
					
					
		motion = move_and_slide(motion,UP)
	else:
		motion = Vector2(0,0)
		$AnimatedSprite.play("killed")
		$hitbox.disabled = true
		



func _on_Area2D_body_entered(body):
	if "Fire" in body.name:
		body.contact()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack1" || $AnimatedSprite.animation == "attack2":
		isAttacking = false; # Replace with function body.
		$Slash/CollisionShape2D.disabled = true
