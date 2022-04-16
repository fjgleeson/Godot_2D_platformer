extends KinematicBody2D


const UP = Vector2(0, -0.5)
const GRAVITY = 10
const MAXFALLSPEED = 200
const MAXSPEED = 250
const ACCEL = 200
const JUMP = 350

export (float) var max_health = 1
onready var health = max_health setget _set_health
var motion = Vector2()
var elapsed_seconds = 0

var despawn_time = 3

var player = null

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)

func _physics_process(delta):
	if health == 1:
		
		motion.y += GRAVITY
		
		motion = move_and_slide(motion,UP)
		
		$AnimatedSprite.play("Idle")
		
		#motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
		
		if player:
			#motion = position.direction_to(player.position) * ACCEL
		#motion = move_and_slide(motion,UP)
		
			var player_direction = player.position - self.position
			if player_direction.x > player_direction.y:
				player_direction.y = 0
			else:
				player_direction.y = 0
			
			
			#if player.position.y == 0:
			#	player_direction.y = 0
			
			move_and_slide(ACCEL * player_direction.normalized())
	else:
		motion = Vector2(0,0)
		$AnimatedSprite.play("Death")
		$CollisionShape2D.disabled = true
		$Hitbox/CollisionShape2D.disabled = true
		
		elapsed_seconds += delta
		if elapsed_seconds > despawn_time:
			elapsed_seconds = 0
			queue_free()


func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		body.contact()
	
func _on_detection_zone_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_detection_zone_body_exited(body):
	if "Player" in body.name:
		player = null 
func damage(amount):
	_set_health(health - amount)
	


