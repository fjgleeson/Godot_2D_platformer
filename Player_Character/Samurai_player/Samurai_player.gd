extends KinematicBody2D
signal health_updated(health)
const UP = Vector2(0, -0.70)

const GRAVITY = 14

const MAXFALLSPEED = 200

const MAXSPEED = 250

const ACCEL = 30

const JUMP = 300

export (float) var max_health = 1

onready var health = max_health setget _set_health

var motion = Vector2()

var facing_right = true

var isAttacking = false

var jumps = 0

var is_jumping = false


var elapsed_seconds = 0

var reset = 3



func damage(amount):
	_set_health(health - amount)


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		


	
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
			
			
			
		
		motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
		
		if Input.is_action_pressed("right") && isAttacking == false:
			motion.x += ACCEL
			facing_right = true
			$AnimatedSprite.play("run")
			$SlashR/right.disabled = true
			$SlashR/lower.disabled = true
			$SlashL/left.disabled = true
			$SlashL/lower.disabled = true
			
		elif Input.is_action_pressed("left") && isAttacking == false:
			motion.x -= ACCEL
			facing_right = false
			$AnimatedSprite.play("run")
			$SlashR/right.disabled = true
			$SlashR/lower.disabled = true
			$SlashL/left.disabled = true
			$SlashL/lower.disabled = true
		else:
			motion.x = lerp(motion.x,0,0.6)
			
			if (isAttacking == false):
				$AnimatedSprite.play("idle")
				$SlashR/right.disabled = true
				$SlashR/lower.disabled = true
				$SlashL/left.disabled = true
				$SlashL/lower.disabled = true
		if Input.is_action_just_pressed("mouse_left_click"):
			if is_jumping == false:
				isAttacking = true
				if(facing_right == false):
					
					#self.position.x -= 20
					$AnimatedSprite.play("attack1")
					$SlashL/left.disabled = false
					$SlashL/lower.disabled = false
				else:
					$AnimatedSprite.play("attack1")
					$SlashR/right.disabled = false
					$SlashR/lower.disabled = false
				
				
				
		if Input.is_action_just_pressed("mouse_right_click"):
			if is_jumping == false:
				isAttacking = true
				if(facing_right == false):
					
					#$Slash/CollisionShape2D.position.x = $Slash/CollisionShape2D.position.x * -1
					$AnimatedSprite.play("attack2")
					$SlashL/left.disabled = false
					$SlashL/lower.disabled = false
				else:
					
					$AnimatedSprite.play("attack2")
					$SlashR/right.disabled = false
					$SlashR/lower.disabled = false
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
		
		
		elapsed_seconds += delta
		if elapsed_seconds > reset:
			elapsed_seconds = 0
			get_tree().change_scene("res://Menus/Menu.tscn")
		

func getHealth():
	if self.health == 1:
		return 1
	else:
		return 0

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		body.damage(1)
		


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack1" || $AnimatedSprite.animation == "attack2":
		isAttacking = false
		$SlashR/right.disabled = true
		$SlashR/lower.disabled = true
		$SlashL/left.disabled = true
		$SlashL/lower.disabled = true


func _on_SlashR_body_entered(body):
	if "Enemy" in body.name:
		body.damage(1)
