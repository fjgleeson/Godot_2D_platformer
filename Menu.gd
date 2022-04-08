extends Control



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene # This will lead to beginning of game, place level here

func _on_Exit_pressed():
	get_tree().quit()
