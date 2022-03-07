extends KinematicBody2D

signal health_updated(health)
signal killed()
const UP = Vector2(0, -0.5)
const GRAVITY = 10
const MAXFALLSPEED = 200
const MAXSPEED = 150
const ACCEL = 20
const JUMP = 350

export (float) var max_health = 1

onready var health = max_health setget _set_health

var motion = Vector2()

var look = 1

func damage(amount):
	_set_health(health - amount)
func kill():
	pass
	
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func contact():
		damage(1)
		
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	if health == 1:
		motion.x = MAXSPEED * look
		if look == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		
		$AnimatedSprite.play("walk")
		
		motion.y += GRAVITY
		
		motion = move_and_slide(motion,UP)
		
		if is_on_wall():
			look = look * -1
	else:
		motion = Vector2(0,0)
		$AnimatedSprite.play("death")
		$Timer.start(2)
		if $Timer.stop() == true:
			queue_free()
			


func _on_hitbox_body_entered(body):
	if "Player" in body.name:
		body.contact() # Replace with function body.


func _on_Timer_timeout():
	if(health == 0):
		queue_free()
