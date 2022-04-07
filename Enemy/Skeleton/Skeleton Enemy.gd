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
var look = 1
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
		
		if player:
			var player_direction = player.position - self.position
			if player_direction.x > player_direction.y:
				$AnimatedSprite.play("Walk")
				player_direction.y = 0
				$AnimatedSprite.flip_h = false
				look = 1
			else:
				player_direction.y = 0
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("Walk")
				look = 0
			
			
			move_and_slide(ACCEL * player_direction.normalized())
			
			
		else:
			$AnimatedSprite.play("Idle")
			
		$"Swing Box/left".disabled = true
		$"Swing Box/right".disabled = true
	else:
		
		motion = Vector2(0,0)
		$AnimatedSprite.play("Death")
		$CollisionShape2D.disabled = true
		$"Swing Box/left".disabled = true
		$"Swing Box/right".disabled = true
		
		elapsed_seconds += delta
		if elapsed_seconds > despawn_time:
			elapsed_seconds = 0
			queue_free()
	
func _on_detection_zone_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_detection_zone_body_exited(body):
	if "Player" in body.name:
		player = null
		
func damage(amount):
	_set_health(health - amount)


func _on_Range_body_entered(body):
	if "Player" in body.name:
		if look == 0:
			
			$AnimatedSprite.play("Attack")
			$"Swing Box/right".disabled = false
		else:
			#$AnimatedSprite.flip_h
			$AnimatedSprite.play("Death")
			$"Swing Box/left".disabled = false

func _on_Swing_Box_body_entered(body):
	if "Player" in body.name:
		body.damage(1)
