extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene("res://Level/Level 0/Level 0.tscn") # This will lead to beginning of game, place level here

func _on_Exit_pressed():
	get_tree().quit()
