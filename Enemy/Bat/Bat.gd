extends KinematicBody2D

export(PackedScene) var Pebble

var health = 1

var elapsed_seconds = 0

var despawn_time = 2

func _physics_process(delta):
	if health == 1:
		
		$AnimatedSprite.play("Idle")
		
		
		elapsed_seconds += delta
		if elapsed_seconds > despawn_time:
			elapsed_seconds = 0
			var pebble = preload("res://Items/Pebble/Pebble.tscn").instance()
			
			add_child(pebble)
			pebble.position += Vector2(0, 15)
			

