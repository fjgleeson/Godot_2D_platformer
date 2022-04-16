extends KinematicBody2D



const UP = Vector2(0, -2)


var GRAVITY = 10

var MAXFALLSPEED = 200

var MAXSPEED = 150

var ACCEL = 50

var motion = Vector2()

func _physics_process(delta):
		motion.y += GRAVITY
		
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED
		
		
		motion = move_and_slide(motion,UP)
		
		motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
		


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.damage(1)
